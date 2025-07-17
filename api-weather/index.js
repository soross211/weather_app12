const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

// Connect to MySQL database
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '', // set your MySQL root password if any
  database: 'weather_db'
});

db.connect(err => {
  if (err) throw err;
  console.log('Data connection successfully');
});

// View all weather information
app.get('/weather', (req, res) => {
  db.query('SELECT * FROM weather', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// Add new weather information
app.post('/weather', (req, res) => {
  const { location, temperature, conditions } = req.body;
  if (!location || temperature === undefined || conditions === undefined) {
    return res.status(400).json({ error: 'Location, temperature, and conditions are required' });
  }
  db.query(
    'SELECT * FROM weather WHERE location = ?',
    [location],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      if (results.length > 0) {
        return res.status(400).json({ error: 'City already exists' });
      }
      db.query(
        'INSERT INTO weather (location, temperature, conditions) VALUES (?, ?, ?)',
        [location, temperature, conditions],
        (err, result) => {
          if (err) return res.status(500).json({ error: err.message });
          res.json({ id: result.insertId, location, temperature, conditions });
        }
      );
    }
  );
});

// Update weather information by city
// This endpoint only updates existing records. It does NOT add new cities if they don't exist.
app.put('/weather/:city', (req, res) => {
  const city = req.params.city;
  const { temperature, conditions } = req.body;
  if (temperature === undefined || conditions === undefined) {
    return res.status(400).json({ error: 'Temperature and conditions are required' });
  }
  db.query(
    'UPDATE weather SET temperature = ?, conditions = ? WHERE location = ?',
    [temperature, conditions, city],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      if (result.affectedRows === 0) {
        return res.status(404).json({ error: 'City not found' });
      }
      res.json({ message: 'City updated successfully' });
    }
  );
});

// Delete weather information by city
app.delete('/weather/:city', (req, res) => {
  const city = req.params.city;
  db.query(
    'DELETE FROM weather WHERE location = ?',
    [city],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      if (result.affectedRows === 0) {
        return res.status(404).json({ error: 'City not found' });
      }
      res.json({ message: 'City deleted successfully' });
    }
  );
});

// Delete duplicate entries, keeping the one with the smallest id
app.delete('/weather/duplicates', (req, res) => {
  db.query(
    `DELETE w1 FROM weather w1
     INNER JOIN weather w2
     WHERE
       w1.location = w2.location AND
       w1.id > w2.id;`,
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: 'Duplicate cities deleted successfully' });
    }
  );
});

app.listen(3001, () => {
  console.log('server running on port 3001');
});