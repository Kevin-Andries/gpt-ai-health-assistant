import fs from "fs";
import firebaseAdmin from "firebase-admin";
import { getDirname } from "./getDirname.js";

const serviceAccountKey = JSON.parse(
  fs.readFileSync(`${getDirname(import.meta.url)}/../serviceAccountKey.json`)
);

export const firebaseApp = firebaseAdmin.initializeApp({
  credential: firebaseAdmin.credential.cert(serviceAccountKey),
});
