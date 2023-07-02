import { AppError } from "../../../utils/AppError.js";
import { queriesCollection } from "../../../utils/mongodb.js";

const DAILY_ASSISTANT_REQUEST_LIMIT = process.env.DAILY_ASSISTANT_REQUEST_LIMIT;

export async function checkDailyRequestLimit(userId, next) {
  const startOfDay = new Date();
  startOfDay.setHours(0, 0, 0, 0);
  const startOfDaytimestamp = Math.floor(startOfDay.getTime() / 1000);

  const endOfDay = new Date();
  endOfDay.setHours(23, 59, 59, 999);
  const endOfDaytimestamp = Math.floor(endOfDay.getTime() / 1000);

  const todayRequestsCount = await queriesCollection.countDocuments({
    userId,
    createdAt: {
      $gte: startOfDaytimestamp,
      $lt: endOfDaytimestamp,
    },
  });

  if (todayRequestsCount > DAILY_ASSISTANT_REQUEST_LIMIT) {
    throw new AppError(429, "Daily request limit exceeded");
  }
}
