const { env } = require("../config/env");

function buildAppRedirect({ provider, status, message }) {
  const redirect = new URL(`${env.appRedirectScheme}://${env.appRedirectHost}`);
  redirect.searchParams.set("provider", provider);
  redirect.searchParams.set("status", status);
  if (message) {
    redirect.searchParams.set("message", message);
  }
  return redirect.toString();
}
module.exports = { buildAppRedirect };
