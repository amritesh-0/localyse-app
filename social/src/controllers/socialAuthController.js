const {
  buildAppRedirect,
} = require("../lib/appRedirect");
const { HttpError } = require("../lib/httpError");
const { createOAuthState, consumeOAuthState } = require("../services/oauthStateService");
const {
  upsertSocialConnection,
  listConnectionsForUser,
  removeConnectionForUser,
} = require("../services/socialConnectionService");
const youtubeProvider = require("../services/providers/youtubeProvider");
const instagramProvider = require("../services/providers/instagramProvider");

const providerServices = {
  youtube: youtubeProvider,
  instagram: instagramProvider,
};

function getProviderService(provider) {
  const service = providerServices[provider];
  if (!service) {
    throw new HttpError(404, `Unsupported provider: ${provider}`);
  }
  return service;
}

function successRedirectForTarget(state, provider) {
  return buildAppRedirect({
    provider,
    status: "success",
  });
}

function errorRedirectForTarget(state, provider, message) {
  return buildAppRedirect({
    provider,
    status: "error",
    message,
  });
}

function respondWithRedirect(res, targetUrl) {
  res.redirect(302, targetUrl);
}

async function createOAuthSession(req, res) {
  const provider = req.params.provider;
  const service = getProviderService(provider);

  const firebaseUid = req.appUser.uid;
  const requestedUid = req.body.uid || firebaseUid;
  if (requestedUid !== firebaseUid) {
    throw new HttpError(403, "UID mismatch between request and verified user.");
  }

  const state = await createOAuthState({
    provider,
    userId: firebaseUid,
    firebaseUid,
    meta: {
      source: "app",
      provider,
      userAgent: req.headers["user-agent"],
    },
  });

  const authorizationUrl = service.buildAuthorizationUrl({ state });
  console.log("oauth.start", { provider, firebaseUid, redirectTarget: "app" });
  res.status(201).json({
    provider,
    authorizationUrl,
  });
}

async function handleOAuthCallback(req, res) {
  const provider = req.params.provider;
  const service = getProviderService(provider);
  const code = req.query.code;

  if (!code) {
    throw new HttpError(400, "Missing provider authorization code.");
  }

  let state;
  try {
    state = await consumeOAuthState(req.query.state, provider);
  } catch (error) {
    if (state) {
      return respondWithRedirect(
        res,
        errorRedirectForTarget(state, provider, error.message),
      );
    }
    throw error;
  }

  try {
    console.log("oauth.callback", { provider, firebaseUid: state.firebaseUid });
    const tokenResponse = await service.exchangeCodeForTokens({ code });
    const accessToken = tokenResponse.access_token;
    const refreshToken = tokenResponse.refresh_token;
    const tokenType = tokenResponse.token_type;
    const expiresIn = tokenResponse.expires_in;
    const scopes = Array.isArray(tokenResponse.scope)
      ? tokenResponse.scope
      : String(tokenResponse.scope || "")
          .split(/[ ,]/)
          .map((value) => value.trim())
          .filter(Boolean);

    const profileData = await service.fetchProfile({
      accessToken,
      providerAccountId:
        tokenResponse.user_id || tokenResponse.id || tokenResponse.channel_id,
    });

    await upsertSocialConnection({
      userId: state.firebaseUid,
      provider,
      providerAccountId: profileData.providerAccountId,
      accessToken,
      refreshToken,
      tokenType,
      scopes,
      expiresIn,
      profile: profileData.profile,
    });

    return respondWithRedirect(
      res,
      successRedirectForTarget(state, provider),
    );
  } catch (error) {
    return respondWithRedirect(
      res,
      errorRedirectForTarget(state, provider, error.message),
    );
  }
}

async function listConnections(req, res) {
  const connections = await listConnectionsForUser(req.appUser.uid);
  res.json({
    connections: connections.map((connection) => ({
      provider: connection.provider,
      profile: connection.profile,
      connectedAt: connection.connectedAt,
      expiresAt: connection.expiresAt,
      lastSyncedAt: connection.lastSyncedAt,
    })),
  });
}

async function disconnectProvider(req, res) {
  const provider = req.params.provider;
  getProviderService(provider);

  await removeConnectionForUser(req.appUser.uid, provider);
  res.status(204).send();
}

module.exports = {
  createOAuthSession,
  handleOAuthCallback,
  listConnections,
  disconnectProvider,
};
