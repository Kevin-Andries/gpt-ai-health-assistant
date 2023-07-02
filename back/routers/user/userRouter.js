import { Router } from "express";
import { protect } from "../../utils/protect.js";
import { getUserData } from "../../controllers/userController/getUserData.js";
import { updateUserData } from "../../controllers/userController/updateUserData.js";
import { deleteUserAccount } from "../../controllers/userController/deleteUserAccount.js";

const userRouter = Router();

userRouter.get("/", protect, getUserData);
userRouter.post("/", protect, updateUserData);
userRouter.delete("/", protect, deleteUserAccount);

export default userRouter;
