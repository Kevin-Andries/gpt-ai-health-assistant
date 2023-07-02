import { usersCollection } from "../../../utils/mongodb.js";

export async function incrementRequestCount(userId) {
  await usersCollection.findOneAndUpdate(
    {
      userId,
    },
    {
      $inc: {
        totalRequestCount: 1,
      },
    }
  );
}
