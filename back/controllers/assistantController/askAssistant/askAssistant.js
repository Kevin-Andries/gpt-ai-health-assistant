import { catchRouteError } from "../../../utils/catchRouteError.js";
import { AppError } from "../../../utils/AppError.js";
import { checkDailyRequestLimit } from "./checkDailyRequestLimit.js";
import {
  usersCollection,
  crucialInfoCollection,
  conversationsCollection,
} from "../../../utils/mongodb.js";
import { isUserPremium } from "../../../utils/isUserPremium.js";
import { buildPrompt } from "./buildPrompt.js";
import { gpt } from "../../../utils/openai.js";
import { saveQuery } from "./saveQuery.js";
import { saveMessage } from "./saveMessage.js";
import { incrementRequestCount } from "./incrementRequestCount.js";
import { extractAndSaveCrucialInfo } from "./extractAndSaveCruciaInfo.js";

// TODO: update front with new res objects
// TODO: put a tokens limitation in queries

export const askAssistant = catchRouteError(async (req, res, next) => {
  const queryTimestamp = Date.now();
  const userId = req.userData.user_id;
  const revenueCatAppUserId = req.headers["rc-app-user-id"];
  const message = req.body.message;

  if (!message) return next(new AppError(400, "Message is required"));

  await checkDailyRequestLimit(userId, next); // Breaks if user has reached daily request limit

  const isPremium = await isUserPremium(revenueCatAppUserId);
  const userDoc = await usersCollection.findOne({
    userId,
  });

  if (!userDoc) return next(new AppError(404, "User not found"));

  // Check if user has reached free request limit
  if (userDoc.totalAskAssistantRequestCount >= 20 && !isPremium) {
    return next(
      new AppError(
        403,
        "You have reached your free request limit. Please upgrade to premium to continue."
      )
    );
  }

  // Fetch last 5 messages from user
  const recentMessagesDocsArray = await conversationsCollection
    .find({
      userId,
    })
    .sort({ createdAt: -1 })
    .limit(5)
    .toArray();
  // Fetch last 5 extracted crucial info from user
  const crucialInfoDocsArray = await crucialInfoCollection
    .find({
      userId,
    })
    .sort({ createdAt: -1 })
    .limit(5)
    .toArray();

  const prompt = buildPrompt(message, userDoc.data, crucialInfoDocsArray);
  const gptResponse = await gpt(prompt, recentMessagesDocsArray);

  res.json({ message: gptResponse.text });

  // Save query data
  saveQuery(
    userId,
    message,
    prompt,
    gptResponse.text,
    gptResponse.tokensUsed,
    queryTimestamp
  ),
    // Save message from user
    saveMessage(userId, "user", message, queryTimestamp),
    // Save answer from assistant
    saveMessage(userId, "assistant", gptResponse.text, queryTimestamp),
    // Increment requests count for the user
    incrementRequestCount(userId),
    // Extract and save crucial information from the last message
    extractAndSaveCrucialInfo(userId, message, queryTimestamp);
});
