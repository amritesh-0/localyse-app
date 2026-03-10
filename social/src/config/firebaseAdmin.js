const admin = require("firebase-admin");
const { env } = require("./env");

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert({
      projectId: env.firebase.projectId,
      clientEmail: env.firebase.clientEmail,
      privateKey: env.firebase.privateKey,
    }),
    projectId: env.firebase.projectId,
  });
}

module.exports = { admin };
