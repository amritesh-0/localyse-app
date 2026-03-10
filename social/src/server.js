const { app } = require("./app");
const { connectDatabase } = require("./config/database");
const { env } = require("./config/env");

async function start() {
  await connectDatabase();

  app.listen(env.port, () => {
    console.log(`social backend listening on port ${env.port}`);
  });
}

start().catch((error) => {
  console.error("failed to start social backend", error);
  process.exit(1);
});
