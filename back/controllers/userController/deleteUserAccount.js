import { catchRouteError } from "../../utils/catchRouteError.js";
import { firebaseApp } from "../../utils/firebase.js";
import {
  conversationsCollection,
  crucialInfoCollection,
  queriesCollection,
  usersCollection,
} from "../../utils/mongodb.js";

export const deleteUserAccount = catchRouteError(async (req, res) => {
  const userId = req.userData.user_id;

  await Promise.all([
    usersCollection.deleteOne({ userId }),
    crucialInfoCollection.deleteMany({ userId }),
    conversationsCollection.deleteMany({ userId }),
    queriesCollection.deleteMany({ userId }),
    firebaseApp.auth().deleteUser(userId),
  ]);

  res.sendStatus(204);
});
