const axios = require("axios");

const { env } = require("../../config/env");
const { HttpError } = require("../../lib/httpError");

function buildAuthorizationUrl({ state }) {
  const url = new URL("https://www.instagram.com/oauth/authorize");
  url.searchParams.set("client_id", env.instagram.clientId);
  url.searchParams.set("redirect_uri", env.instagram.callbackUrl);
  url.searchParams.set("response_type", "code");
  url.searchParams.set("scope", env.instagram.scopes.join(","));
  url.searchParams.set("state", state);
  return url.toString();
}

async function exchangeCodeForTokens({ code }) {
  try {
    const params = new URLSearchParams({
      client_id: env.instagram.clientId,
      client_secret: env.instagram.clientSecret,
      grant_type: "authorization_code",
      redirect_uri: env.instagram.callbackUrl,
      code,
    });

    const response = await axios.post(
      "https://api.instagram.com/oauth/access_token",
      params.toString(),
      {
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      },
    );

    return response.data;
  } catch (error) {
    throw new HttpError(502, "Failed to exchange Instagram authorization code.", error.response?.data || error.message);
  }
}

async function fetchProfile({ accessToken, providerAccountId }) {
  try {
    const response = await axios.get("https://graph.instagram.com/me", {
      params: {
        fields: "id,username,account_type",
        access_token: accessToken,
      },
    });

    return {
      providerAccountId: providerAccountId || response.data.id,
      profile: {
        instagramUserId: response.data.id,
        username: response.data.username,
        accountType: response.data.account_type,
      },
    };
  } catch (error) {
    throw new HttpError(502, "Failed to fetch Instagram profile.", error.response?.data || error.message);
  }
}

module.exports = {
  buildAuthorizationUrl,
  exchangeCodeForTokens,
  fetchProfile,
};
