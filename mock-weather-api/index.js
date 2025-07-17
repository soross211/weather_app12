const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 3005;

app.use(cors());

// Mock weather data
const weatherData = [
  {
    city: 'New York',
    temperature: 26,
    condition: 'Sunny',
    icon: 'wb_sunny_rounded',
  },
  {
    city: 'Vientiane',
    temperature: 32,
    condition: 'Partly Cloudy',
    icon: 'wb_cloudy_rounded',
  },
  {
    city: 'Luang Prabang',
    temperature: 28,
    condition: 'Rainy',
    icon: 'beach_access_rounded',
  },
  {
    city: 'Pakse',
    temperature: 30,
    condition: 'Thunderstorm',
    icon: 'flash_on_rounded',
  },
];

app.get('/weather', (req, res) => {
  res.json(weatherData);
});

app.listen(PORT, () => {
  console.log(`Mock Weather API running at http://localhost:${PORT}`);
});
