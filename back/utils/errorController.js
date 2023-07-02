import { AppError } from "./AppError.js";

export default function errorController(err, _req, res, _next) {
  // Operational erros
  if (err instanceof AppError) {
    if (!err.message) {
      return res.sendStatus(err.code);
    }

    return res.status(err.code || 500).json({ errorMessage: err.message });
  }

  // Non operational errors
  // TODO: log and notify me
  console.log("NOE:", err);
  res.status(500).json({ errorMessage: "Something went wrong" });
}
