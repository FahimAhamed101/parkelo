require("dotenv").config({ quiet: true });

const app = require("./app");
const { connectDb } = require("./config/db");

const port = process.env.PORT || 5000;

async function startServer() {
  await connectDb();

  app.listen(port, () => {
    console.log(`Parkealo API listening on port ${port}`);
  });
}

startServer().catch((error) => {
  console.error("Failed to start server:", error.message);
  process.exit(1);
});
