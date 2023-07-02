import { extractCrucialInfo } from "../../../utils/openai.js";
import { crucialInfoCollection } from "../../../utils/mongodb.js";

export async function extractAndSaveCrucialInfo(
  userId,
  message,
  queryTimestamp
) {
  const crucialInfo = await extractCrucialInfo(message);
  await crucialInfoCollection.insertOne({
    userId,
    crucialInfo,
    createdAt: queryTimestamp,
  });
}
