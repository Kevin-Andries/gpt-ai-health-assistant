import { AppError } from "../../utils/AppError.js";
import { catchRouteError } from "../../utils/catchRouteError.js";
import { usersCollection } from "../../utils/mongodb.js";

export const getUserData = catchRouteError(async (req, res, next) => {
  const userDoc = await usersCollection.findOne(
    {
      userId: req.userData.user_id,
    },
    {
      projection: {
        _id: 0,
        firstName: 1,
        data: 1,
        totalRequestCount: 1,
      },
    }
  );

  if (!userDoc) return next(new AppError(404, "User not found"));

  res.json(userDoc);
});
