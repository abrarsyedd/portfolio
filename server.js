require('dotenv').config();
const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const mysql = require('mysql2/promise');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));

// MySQL pool
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'portfolio_user',
  password: process.env.DB_PASSWORD || 'securepassword',
  database: process.env.DB_DATABASE || 'portfolio_db',
  waitForConnections: true,
  connectionLimit: 10,
  port: process.env.DB_PORT || 3306
});

// API: submit contact
app.post('/api/contact', async (req, res) => {
  const { name, email, message } = req.body;
  if (!name || !email) return res.status(400).json({ error: 'Name and email required' });
  try {
    const [result] = await pool.execute(
      'INSERT INTO contacts (name, email, message) VALUES (?, ?, ?)',
      [name, email, message || null]
    );
    res.json({ success: true, id: result.insertId });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'DB error' });
  }
});

// API: list projects
app.get('/api/projects', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT id, title, description, image, link FROM projects ORDER BY id DESC');
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'DB error' });
  }
});

// fallback to index
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public/index.html'));
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});

