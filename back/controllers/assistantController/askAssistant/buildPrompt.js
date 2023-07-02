import fs from "fs";
import { timestampToDate } from "../../../utils/timestampToDate.js";
import { getDirname } from "../../../utils/getDirname.js";

const TOKEN_BUDGET = 4096 - 500; // TODO: use
const PROMPT = fs.readFileSync(
  `${getDirname(import.meta.url)}/../../../prompts/message/prompt.txt`,
  "UTF-8"
);
const NO_DATA = "No data.";

function parseCrucialInfo(crucialInfoDocsArray) {
  let parsedCrucialInfoString = "";

  crucialInfoDocsArray.forEach((crucialInfoDoc) => {
    const text = crucialInfoDoc.crucialInfo;
    const date = timestampToDate(crucialInfoDoc.createdAt);

    parsedCrucialInfoString += `- Noted on ${date}: ${text}\n`;
  });

  return parsedCrucialInfoString;
}

export function buildPrompt(message, data, crucialInfoDocsArray) {
  const prompt = PROMPT.replace("{{MESSAGE}}", message)
    .replace("{{FOOD_ALLERGIES}}", data.foodAllergies || NO_DATA)
    .replace("{{FOOD_PREFERENCES}}", data.foodPreferences || NO_DATA)
    .replace(
      "{{CRUCIAL_INFO}}",
      parseCrucialInfo(crucialInfoDocsArray) || NO_DATA
    );

  return prompt;
}
