import { firebaseApp } from "./firebase.js";
import { AppError } from "./AppError.js";

export async function protect(req, _res, next) {
  const token = req.headers.token;
  let userDataFromFirebaseToken;

  if (!token || typeof token !== "string") {
    return next(new AppError(401, "missing or invalid token header"));
  }

  try {
    userDataFromFirebaseToken = await firebaseApp.auth().verifyIdToken(token);
  } catch (err) {
    return next(
      new AppError(
        401,
        err.code.includes("id-token-expired")
          ? "your auth token has expired"
          : "your auth token is invalid"
      )
    );
  }

  req.userData = userDataFromFirebaseToken;
  next();
}
