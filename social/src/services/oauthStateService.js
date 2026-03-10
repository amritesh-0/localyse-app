const crypto = require("crypto");

const { env } = require("../config/env");
const { HttpError } = require("../lib/httpError");
const { OAuthState } = require("../models/OAuthState");

function signStateParts(parts) {
  return crypto
    .createHmac("sha256", env.oauthStateSecret)
    .update(parts.join("|"))
    .digest("hex");
}

async function createOAuthState({
  provider,
  userId,
  firebaseUid,
  meta = {},
}) {
  const stateId = crypto.randomUUID();
  const expiresAt = new Date(Date.now() + 10 * 60 * 1000);
  const signature = signStateParts([
    stateId,
    provider,
    userId,
    firebaseUid,
    expiresAt.toISOString(),
  ]);

  await OAuthState.create({
    stateId,
    provider,
    userId,
    firebaseUid,
    signature,
    expiresAt,
    meta,
  });

  return `${stateId}.${signature}`;
}

async function consumeOAuthState(rawState, provider) {
  if (!rawState) {
    throw new HttpError(400, "Missing OAuth state.");
  }

  const [stateId, signature] = String(rawState).split(".");
  if (!stateId || !signature) {
    throw new HttpError(400, "Malformed OAuth state.");
  }

  const state = await OAuthState.findOne({ stateId, provider });
  if (!state) {
    throw new HttpError(400, "OAuth state not found.");
  }

  if (state.consumedAt) {
    throw new HttpError(400, "OAuth state already consumed.");
  }

  if (state.expiresAt.getTime() < Date.now()) {
    throw new HttpError(400, "OAuth state expired.");
  }

  const expectedSignature = signStateParts([
    state.stateId,
    state.provider,
    state.userId,
    state.firebaseUid,
    state.expiresAt.toISOString(),
  ]);

  if (signature !== expectedSignature || state.signature !== expectedSignature) {
    throw new HttpError(400, "OAuth state signature mismatch.");
  }

  state.consumedAt = new Date();
  await state.save();

  return state;
}

module.exports = { createOAuthState, consumeOAuthState };
