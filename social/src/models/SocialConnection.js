const mongoose = require("mongoose");

const EncryptedPayloadSchema = new mongoose.Schema(
  {
    iv: { type: String, required: true },
    authTag: { type: String, required: true },
    ciphertext: { type: String, required: true },
  },
  { _id: false },
);

const SocialConnectionSchema = new mongoose.Schema(
  {
    userId: { type: String, required: true, index: true },
    provider: {
      type: String,
      required: true,
      enum: ["youtube", "instagram"],
      index: true,
    },
    providerAccountId: { type: String, required: true },
    accessToken: { type: EncryptedPayloadSchema, required: true },
    refreshToken: { type: EncryptedPayloadSchema },
    tokenType: { type: String },
    scopes: { type: [String], default: [] },
    expiresAt: { type: Date },
    profile: { type: mongoose.Schema.Types.Mixed, default: {} },
    connectedAt: { type: Date, default: Date.now },
    lastSyncedAt: { type: Date, default: Date.now },
  },
  {
    timestamps: true,
  },
);

SocialConnectionSchema.index({ userId: 1, provider: 1 }, { unique: true });

module.exports = {
  SocialConnection: mongoose.model("SocialConnection", SocialConnectionSchema),
};
