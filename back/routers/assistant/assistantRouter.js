import { Router } from "express";
import { askAssistant } from "../../controllers/assistantController/askAssistant/askAssistant.js";
import { getConversation } from "../../controllers/assistantController/getConversation.js";
import { protect } from "../../utils/protect.js";

const assistantRouter = Router();

assistantRouter.post("/", protect, askAssistant);
assistantRouter.get("/conversation", protect, getConversation);

export default assistantRouter;
