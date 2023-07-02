import express from "express";
import morgan from "morgan";
import cors from "cors";
import helmet from "helmet";
import errorController from "./utils/errorController.js";
// Routers
import userRouter from "./routers/user/userRouter.js";
import assistantRouter from "./routers/assistant/assistantRouter.js";

const app = express();

// Middlewares
app.use(morgan("tiny"));
app.use(cors());
app.use(helmet());
app.use(express.json());

// Routes
app.use("/user", userRouter);
app.use("/assistant", assistantRouter);

// Error handling
app.use("*", errorController);

export default app;
