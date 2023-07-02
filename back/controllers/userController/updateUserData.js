import { AppError } from "../../utils/AppError.js";
import { catchRouteError } from "../../utils/catchRouteError.js";
import { usersCollection } from "../../utils/mongodb.js";

function validateForm(form) {
  const onlyStringValues = Object.values(form).every((value) => {
    return typeof value === "string";
  });

  if (!onlyStringValues) return false;

  const { firstName, foodPreferences, foodAllergies } = form;

  if (!firstName || firstName.length > 30) return false;
  if (foodPreferences && foodPreferences.length > 200) return false;
  if (foodAllergies && foodAllergies.length > 200) return false;

  return true;
}

export const updateUserData = catchRouteError(async (req, res, next) => {
  const userId = req.userData.user_id;
  const form = {
    ...req.body,
    ...req.body.data,
  };
  delete form.data;
  const isFormValid = validateForm(form);

  if (!isFormValid) {
    return next(new AppError(400, "Invalid form"));
  }

  usersCollection.updateOne(
    {
      userId,
    },
    {
      $set: {
        firstName: req.body.firstName,
        data: req.body.data,
      },
      $setOnInsert: {
        totalRequestCount: 0,
      },
    },
    {
      upsert: true,
    }
  );

  res.sendStatus(204);
});
