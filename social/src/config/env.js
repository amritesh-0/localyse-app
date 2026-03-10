const dotenv = require("dotenv");

dotenv.config();

function required(name) {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

const tokenEncryptionKey = required("TOKEN_ENCRYPTION_KEY");
if (!/^[0-9a-fA-F]{64}$/.test(tokenEncryptionKey)) {
  throw new Error("TOKEN_ENCRYPTION_KEY must be a 64-character hex string.");
}

const env = {
  nodeEnv: process.env.NODE_ENV || "development",
  port: Number(process.env.PORT || 4000),
  mongoUri: required("MONGODB_URI"),
  appBaseUrl: required("APP_BASE_URL"),
  oauthStateSecret: required("OAUTH_STATE_HMAC_SECRET"),
  tokenEncryptionKey,
  appRedirectScheme: process.env.APP_REDIRECT_SCHEME || "localyse",
  appRedirectHost: process.env.APP_REDIRECT_HOST || "social-connect",
  firebase: {
    projectId: required("FIREBASE_PROJECT_ID"),
    clientEmail: required("FIREBASE_CLIENT_EMAIL"),
    privateKey: required("FIREBASE_PRIVATE_KEY").replace(/\\n/g, "\n"),
  },
  youtube: {
    clientId: required("YOUTUBE_CLIENT_ID"),
    clientSecret: required("YOUTUBE_CLIENT_SECRET"),
    callbackUrl: required("YOUTUBE_CALLBACK_URL"),
    scopes: (process.env.YOUTUBE_SCOPES || "")
      .split(" ")
      .map((value) => value.trim())
      .filter(Boolean),
  },
  instagram: {
    clientId: required("INSTAGRAM_CLIENT_ID"),
    clientSecret: required("INSTAGRAM_CLIENT_SECRET"),
    callbackUrl: required("INSTAGRAM_CALLBACK_URL"),
    scopes: (process.env.INSTAGRAM_SCOPES || "")
      .split(",")
      .map((value) => value.trim())
      .filter(Boolean),
  },
};

module.exports = { env };
