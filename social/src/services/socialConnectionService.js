const { encryptJson } = require("../lib/crypto");
const { SocialConnection } = require("../models/SocialConnection");

async function upsertSocialConnection({
  userId,
  provider,
  providerAccountId,
  accessToken,
  refreshToken,
  tokenType,
  scopes,
  expiresIn,
  profile,
}) {
  const expiresAt =
    typeof expiresIn === "number" ? new Date(Date.now() + expiresIn * 1000) : undefined;

  const update = {
    providerAccountId,
    accessToken: encryptJson({ value: accessToken }),
    tokenType,
    scopes: scopes || [],
    profile,
    connectedAt: new Date(),
    lastSyncedAt: new Date(),
  };

  if (refreshToken) {
    update.refreshToken = encryptJson({ value: refreshToken });
  }

  if (expiresAt) {
    update.expiresAt = expiresAt;
  }

  return SocialConnection.findOneAndUpdate(
    { userId, provider },
    { $set: update },
    { upsert: true, new: true, setDefaultsOnInsert: true },
  );
}

async function listConnectionsForUser(userId) {
  return SocialConnection.find({ userId }).sort({ provider: 1 }).lean();
}

async function removeConnectionForUser(userId, provider) {
  return SocialConnection.findOneAndDelete({ userId, provider });
}

module.exports = {
  upsertSocialConnection,
  listConnectionsForUser,
  removeConnectionForUser,
};
