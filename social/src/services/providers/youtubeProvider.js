const axios = require("axios");

const { env } = require("../../config/env");
const { HttpError } = require("../../lib/httpError");

function buildAuthorizationUrl({ state }) {
  const url = new URL("https://accounts.google.com/o/oauth2/v2/auth");
  url.searchParams.set("client_id", env.youtube.clientId);
  url.searchParams.set("redirect_uri", env.youtube.callbackUrl);
  url.searchParams.set("response_type", "code");
  url.searchParams.set("access_type", "offline");
  url.searchParams.set("prompt", "consent");
  url.searchParams.set("scope", env.youtube.scopes.join(" "));
  url.searchParams.set("state", state);
  return url.toString();
}

async function exchangeCodeForTokens({ code }) {
  try {
    const params = new URLSearchParams({
      code,
      client_id: env.youtube.clientId,
      client_secret: env.youtube.clientSecret,
      redirect_uri: env.youtube.callbackUrl,
      grant_type: "authorization_code",
    });

    const response = await axios.post(
      "https://oauth2.googleapis.com/token",
      params.toString(),
      {
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      },
    );

    return response.data;
  } catch (error) {
    throw new HttpError(502, "Failed to exchange YouTube authorization code.", error.response?.data || error.message);
  }
}

async function fetchProfile({ accessToken }) {
  try {
    const [channelResponse, profileResponse] = await Promise.all([
      axios.get("https://www.googleapis.com/youtube/v3/channels", {
        headers: { Authorization: `Bearer ${accessToken}` },
        params: {
          part: "snippet",
          mine: true,
        },
      }),
      axios.get("https://www.googleapis.com/oauth2/v2/userinfo", {
        headers: { Authorization: `Bearer ${accessToken}` },
      }),
    ]);

    const channel = channelResponse.data.items?.[0];
    return {
      providerAccountId: channel?.id || profileResponse.data.id,
      profile: {
        channelId: channel?.id,
        channelTitle: channel?.snippet?.title,
        channelThumbnail: channel?.snippet?.thumbnails?.default?.url,
        googleProfileId: profileResponse.data.id,
        displayName: profileResponse.data.name,
      },
    };
  } catch (error) {
    throw new HttpError(502, "Failed to fetch YouTube profile.", error.response?.data || error.message);
  }
}

module.exports = {
  buildAuthorizationUrl,
  exchangeCodeForTokens,
  fetchProfile,
};
