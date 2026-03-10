const { admin } = require("../config/firebaseAdmin");
const { HttpError } = require("../lib/httpError");

function extractIdToken(req) {
  const authHeader = req.headers.authorization;
  if (authHeader && authHeader.startsWith("Bearer ")) {
    return authHeader.slice("Bearer ".length).trim();
  }

  return (
    req.query.firebase_token ||
    req.query.id_token ||
    req.body?.firebase_token ||
    req.body?.id_token
  );
}

async function authenticateAppUser(req, _res, next) {
  try {
    const idToken = extractIdToken(req);
    if (!idToken) {
      throw new HttpError(401, "Missing Firebase ID token.");
    }

    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.appUser = {
      uid: decodedToken.uid,
      decodedToken,
      idToken,
    };
    next();
  } catch (error) {
    next(new HttpError(401, "Invalid Firebase ID token.", error.message));
  }
}

module.exports = { authenticateAppUser, extractIdToken };
