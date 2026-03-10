const express = require("express");

const { asyncHandler } = require("../lib/asyncHandler");
const { authenticateAppUser } = require("../middleware/authenticateAppUser");
const {
  createOAuthSession,
  handleOAuthCallback,
  listConnections,
  disconnectProvider,
} = require("../controllers/socialAuthController");

const socialAuthRouter = express.Router();

socialAuthRouter.post("/:provider/session", authenticateAppUser, asyncHandler(createOAuthSession));
socialAuthRouter.get("/:provider/callback", asyncHandler(handleOAuthCallback));
socialAuthRouter.get("/social/connections", authenticateAppUser, asyncHandler(listConnections));
socialAuthRouter.delete("/social/:provider", authenticateAppUser, asyncHandler(disconnectProvider));

module.exports = { socialAuthRouter };
