// Import Flutter material package
import 'package:flutter/material.dart';
// Import shared_preferences for local storage
import 'package:shared_preferences/shared_preferences.dart';
// Import custom weather card widget
import 'components/weather_card.dart';
// Import custom logs panel widget
import 'components/logs_panel.dart';
// Import about page
import 'about_page.dart';
// Import weather API service
import 'services/weather_api_service.dart';
// Import city selector widget
import 'components/city_selector.dart';

// Main page widget for the weather app
class WeatherHomePage extends StatefulWidget {
  // Constructor for WeatherHomePage
  const WeatherHomePage({super.key});

  // Create state for WeatherHomePage
  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

// State class for WeatherHomePage
class _WeatherHomePageState extends State<WeatherHomePage> {
  // List of weather data for each city
  List<Map<String, dynamic>> weatherDataList = [];

  // List to store logs
  final List<String> logs = [];
  // Index of the selected city
  int selectedIndex = 0;
  // Whether to show the logs panel
  bool showLogs = false;
  // Weather API service instance
  final WeatherApiService _apiService = WeatherApiService();

  // Getter for current city name
  String get city => weatherDataList[selectedIndex]['city'];
  // Getter for current temperature
  int get temperature => weatherDataList[selectedIndex]['temperature'];
  // Getter for current condition
  String get condition => weatherDataList[selectedIndex]['condition'];
  // Getter for current icon
  IconData get icon => weatherDataList[selectedIndex]['icon'];

  // Add a log entry
  void _addLog(String message) {
    setState(() {
      logs.insert(0, '${DateTime.now().toLocal().toString().substring(0, 19)}: $message');
    });
  }

  // Initialize state
  @override
  void initState() {
    super.initState();
    _fetchAllWeatherFromApi();
    _addLog('App started');
  }

  // Fetch all weather data from API and update the list
  Future<void> _fetchAllWeatherFromApi() async {
    try {
      final allWeather = await _apiService.fetchAllWeather();
      setState(() {
        weatherDataList = allWeather.map((w) => {
          'city': w['location'],
          'temperature': w['temperature'] ?? 0,
          'condition': w['conditions'] ?? 'Unknown',
          'icon': _getIconForCondition(w['conditions'] ?? ''),
        }).toList();
        if (weatherDataList.isEmpty) {
          selectedIndex = 0;
        } else if (selectedIndex >= weatherDataList.length) {
          selectedIndex = 0;
        }
      });
      _addLog('Loaded all weather data from API');
    } catch (e) {
      _addLog('Failed to load weather data from API: $e');
    }
  }

  // Save selected city index to local storage
  Future<void> _saveWeatherData() async {
    final prefs = await SharedPreferences.getInstance(); // Get preferences
    await prefs.setInt('selectedIndex', selectedIndex); // Save index
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Weather data saved!')),
      );
      _addLog('Saved selected city: $city');
    }
  }

  // Fetch weather from API and update city data
  Future<void> _fetchAndSetWeather(String city, {int? index}) async {
    try {
      final allWeather = await _apiService.fetchAllWeather();
      final found = allWeather.firstWhere(
        (w) => (w['location'] as String).toLowerCase() == city.toLowerCase(),
        orElse: () => {},
      );
      if (found.isNotEmpty) {
        setState(() {
          final weather = {
            'city': found['location'],
            'temperature': found['temperature'] ?? 0,
            'condition': found['conditions'] ?? 'Unknown',
            'icon': _getIconForCondition(found['conditions'] ?? ''),
          };
          if (index != null && index < weatherDataList.length) {
            weatherDataList[index] = weather;
          } else {
            weatherDataList.add(weather);
            selectedIndex = weatherDataList.length - 1;
          }
        });
        _addLog('Fetched weather for $city from API');
      } else {
        _addLog('No weather data found for $city');
      }
    } catch (e) {
      _addLog('Failed to fetch weather for $city: $e');
    }
  }

  // Add new city and weather to API
  Future<void> _addWeatherToApi(String city, int temperature, String condition) async {
    try {
      await _apiService.addWeather(city, temperature, condition);
      _addLog('Added $city to API');
      await _fetchAllWeatherFromApi();
    } catch (e) {
      _addLog('Failed to add $city to API: $e');
    }
  }

  // Add this method to delete weather from the API
  Future<void> _deleteWeatherFromApi(String city) async {
    try {
      await _apiService.deleteWeather(city);
      _addLog('Deleted $city from API');
      await _fetchAllWeatherFromApi();
    } catch (e) {
      _addLog('Failed to delete $city from API: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete $city: $e')),
        );
      }
    }
  }

  // Handle city change from dropdown
  void _onCityChanged(int? index) {
    if (index != null) {
      setState(() {
        selectedIndex = index; // Update selected index
      });
      _fetchAndSetWeather(weatherDataList[index]['city'], index: index);
      _addLog('Changed city to: ${weatherDataList[index]['city']}');
    }
  }

  // Get icon for a given condition
  IconData _getIconForCondition(String cond) {
    final c = cond.toLowerCase();
    if (c.contains('sun')) return Icons.wb_sunny_rounded;
    if (c.contains('cloud')) return Icons.wb_cloudy_rounded;
    if (c.contains('rain')) return Icons.beach_access_rounded;
    if (c.contains('thunder')) return Icons.flash_on_rounded;
    return Icons.wb_sunny_rounded;
  }

  // Add city dialog
  void _showCityDialog({bool isEdit = false}) {
    final isAdding = !isEdit && weatherDataList.length < 5;
    final cityController = TextEditingController(text: isEdit ? weatherDataList[selectedIndex]['city'] : '');
    final temperatureController = TextEditingController(text: isEdit ? weatherDataList[selectedIndex]['temperature'].toString() : '');
    final conditionController = TextEditingController(text: isEdit ? weatherDataList[selectedIndex]['condition'] : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit City' : 'Add City'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                TextField(
                  controller: temperatureController,
                  decoration: const InputDecoration(labelText: 'Temperature'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: conditionController,
                  decoration: const InputDecoration(labelText: 'Condition'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isEdit) {
                  _addLog('Cancelled editing city: ${weatherDataList[selectedIndex]['city']}');
                } else {
                  _addLog('Cancelled adding new city');
                }
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final city = cityController.text.trim();
                final temperature = int.tryParse(temperatureController.text.trim()) ?? 0;
                final condition = conditionController.text.trim();

                if (city.isEmpty || condition.isEmpty || (isEdit && temperature == 0)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                if (isEdit) {
                  await _deleteWeatherFromApi(weatherDataList[selectedIndex]['city']);
                }

                await _addWeatherToApi(city, temperature, condition);
                Navigator.of(context).pop();
                _addLog('${isEdit ? 'Updated' : 'Added'} city: $city');
              },
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  // Build the widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.18),
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: const Text(
            'Weather App',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.blueAccent, size: 28),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutPage()),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Weather Card
                if (weatherDataList.isNotEmpty)
                  WeatherCard(
                    city: city,
                    temperature: temperature,
                    condition: condition,
                    icon: icon,
                    onSave: () {},
                    iconColor: Colors.blueAccent,
                  ),
                const SizedBox(height: 24),
                // City Selector
                CitySelector(
                  selectedIndex: selectedIndex,
                  weatherDataList: weatherDataList,
                  onCityChanged: (index) {
                    if (index != null) setState(() => selectedIndex = index);
                  },
                  onAdd: _showCityDialog,
                  onEdit: () => _showCityDialog(isEdit: true),
                  onDelete: () {
                    if (weatherDataList.isNotEmpty) {
                      _deleteWeatherFromApi(weatherDataList[selectedIndex]['city']);
                    }
                  },
                  iconColor: Colors.purpleAccent,
                ),
                const SizedBox(height: 24),
                // Logs Panel
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: showLogs
                      ? LogsPanel(logs: logs)
                      : SizedBox.shrink(),
                ),
                const SizedBox(height: 18),
                // Toggle logs button
                ElevatedButton.icon(
                  onPressed: () => setState(() => showLogs = !showLogs),
                  icon: Icon(showLogs ? Icons.visibility_off : Icons.visibility, color: Colors.blueAccent),
                  label: Text(showLogs ? 'Hide Logs' : 'Show Logs'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.85),
                    foregroundColor: Colors.blueAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
