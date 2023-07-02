import dotenv from "dotenv";
import { getDirname } from "./utils/getDirname.js";

const __dirname = getDirname(import.meta.url);

dotenv.config({
  path: `${__dirname}/.env`,
});
dotenv.config({
  path: `${__dirname}/.env.${process.env.NODE_ENV}`,
});
