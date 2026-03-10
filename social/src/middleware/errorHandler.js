function errorHandler(error, _req, res, _next) {
  const status = error.status || 500;
  const payload = {
    message: error.message || "Internal server error",
  };

  if (error.details) {
    payload.details = error.details;
  }

  if (status >= 500) {
    console.error(error);
  }

  res.status(status).json(payload);
}

module.exports = { errorHandler };
