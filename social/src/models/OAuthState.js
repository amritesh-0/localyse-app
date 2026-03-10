const mongoose = require("mongoose");

const OAuthStateSchema = new mongoose.Schema(
  {
    stateId: { type: String, required: true, unique: true, index: true },
    provider: {
      type: String,
      required: true,
      enum: ["youtube", "instagram"],
      index: true,
    },
    userId: { type: String, required: true, index: true },
    firebaseUid: { type: String, required: true, index: true },
    signature: { type: String, required: true },
    expiresAt: { type: Date, required: true, index: true },
    consumedAt: { type: Date, default: null },
    meta: { type: mongoose.Schema.Types.Mixed, default: {} },
  },
  {
    timestamps: true,
  },
);

module.exports = {
  OAuthState: mongoose.model("OAuthState", OAuthStateSchema),
};
