import { catchRouteError } from "../../utils/catchRouteError.js";
import { conversationsCollection } from "../../utils/mongodb.js";

export const getConversation = catchRouteError(async (req, res) => {
  const userId = req.userData.user_id;

  const conversation = await conversationsCollection
    .find(
      {
        userId,
      },
      { projection: { _id: 0 } }
    )
    .sort({ createdAt: -1 })
    .limit(50)
    .toArray();

  res.json(conversation);
});
