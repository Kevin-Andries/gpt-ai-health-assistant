import { queriesCollection } from "../../../utils/mongodb.js";

export async function saveQuery(
  userId,
  message,
  prompt,
  gptResponseText,
  tokensUsed,
  queryTimestamp
) {
  await queriesCollection.insertOne({
    userId,
    message,
    prompt,
    gptResponseText,
    tokensUsed,
    createdAt: queryTimestamp,
  });
}
