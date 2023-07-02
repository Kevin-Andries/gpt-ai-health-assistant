import fs from "fs";
import { getDirname } from "./getDirname.js";
import { Configuration, OpenAIApi } from "openai";

const configuration = new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
});
const openai = new OpenAIApi(configuration);
const __dirname = getDirname(import.meta.url);
const SYSTEM_MESSAGE = fs.readFileSync(
  `${__dirname}/../prompts/message/system_message.txt`,
  "UTF-8"
);
const EXTRACT_CRUCIAL_INFO_PROMPT = fs.readFileSync(
  `${__dirname}/../prompts/extract_crucial_info.txt`,
  "UTF-8"
);

export async function gpt(prompt, recentMessagesDocsArray) {
  const recentMessages = recentMessagesDocsArray
    .reverse()
    .map((messageDoc) => ({
      role: messageDoc.author === "user" ? "user" : "assistant",
      content: messageDoc.message,
    }));

  const response = await openai.createChatCompletion({
    model: process.env.GPT_CHAT_MODEL,
    temperature: 0.3,
    // TODO: add max_tokens
    messages: [
      {
        role: "system",
        content: SYSTEM_MESSAGE,
      },
      ...recentMessages,
      {
        role: "user",
        content: prompt,
      },
    ],
  });

  return {
    tokensUsed: response.data.usage.total_tokens,
    text: response.data.choices[0].message.content.trim(),
  };
}

export async function extractCrucialInfo(message) {
  const response = await openai.createCompletion({
    model: process.env.GPT_EXTRACT_CRUCIAL_INFO_MODEL,
    prompt: EXTRACT_CRUCIAL_INFO_PROMPT.replace("{{MESSAGE}}", message),
    temperature: 0,
    max_tokens: 200, // TODO: check if that value is good
  });

  return response.data.choices[0].text.trim();
}
