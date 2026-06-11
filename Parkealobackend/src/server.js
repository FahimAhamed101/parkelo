require("dotenv").config({ quiet: true });

const http = require("http");

const app = require("./app");
const { connectDb } = require("./config/db");

const port = process.env.PORT || 5000;

async function startServer() {
  await connectDb();

  const server = http.createServer((req, res) => {
    console.log(`[incoming] ${req.method} ${req.url} host=${req.headers.host || "unknown"}`);
    app(req, res);
  });

  server.listen(port, () => {
    console.log(`Parkealo API listening on port ${port}`);
  });
}

startServer().catch((error) => {
  console.error("Failed to start server:", error.message);
  process.exit(1);
});
