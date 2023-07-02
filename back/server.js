import "./loadEnv.js";
import { initDb } from "./utils/mongodb.js";

(async () => {
  // Initialize MongoDB
  try {
    await initDb();
  } catch (err) {
    console.log("ERROR CONNECTING TO MONGODB", err);
    return process.exit(1);
  }

  const { default: app } = await import("./app.js");

  app.listen(process.env.PORT, () => {
    console.log(`Server is running on port ${process.env.PORT}`);
  });
})();
