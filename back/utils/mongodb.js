import { MongoClient } from "mongodb";

const MONGO_URL = process.env.MONGO_URL;
const DB_NAME = process.env.MONGO_DB_NAME;

const client = new MongoClient(MONGO_URL, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

export let db,
  usersCollection,
  crucialInfoCollection,
  queriesCollection,
  conversationsCollection;

export async function initDb() {
  await client.connect();
  db = client.db(DB_NAME);

  usersCollection = db.collection("users");
  crucialInfoCollection = db.collection("crucialInfo");
  queriesCollection = db.collection("queries");
  conversationsCollection = db.collection("conversations");

  console.log("Connected to MongoDB");
}
