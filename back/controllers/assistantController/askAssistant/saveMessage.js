import { conversationsCollection } from "../../../utils/mongodb.js";

export async function saveMessage(userId, author, message, queryTimestamp) {
  await conversationsCollection.insertOne({
    userId,
    author,
    message,
    createdAt: queryTimestamp,
  });
}
