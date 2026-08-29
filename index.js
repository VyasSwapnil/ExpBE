const express = require("express");
const { Pool } = require("pg");

const app = express();
app.use(express.json());

// Connect to PostgreSQL
const pool = new Pool({
  // This connection string will work both locally via Docker
  // and in production via Render environment variables.
  connectionString:
    process.env.DATABASE_URL ||
    "postgres://myuser:mypassword@localhost:5432/mydatabase",
});

// Test route to verify the database connection
app.get("/users", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM users");
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Database connection failed" });
  }
});

// Determine the port based on the environment
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
