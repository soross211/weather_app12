import 'dart:ui';
import 'package:flutter/material.dart'; // Import Flutter material package

// Stateless widget for showing a waiting-for-API card
class ApiWaitingCard extends StatelessWidget {
  final Color iconColor; // NEW: icon color
  const ApiWaitingCard({super.key, this.iconColor = Colors.grey}); // Constructor

  @override
  Widget build(BuildContext context) {
    // Build method returns a Card widget
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withOpacity(0.18),
                Colors.purpleAccent.withOpacity(0.18),
                Colors.white.withOpacity(0.12),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.18), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(36.0), // Padding inside the card
            child: Column(
              mainAxisSize: MainAxisSize.min, // Column takes minimum space
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [iconColor, Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Icon(
                      Icons.cloud_off, // Cloud off icon
                      size: 100, // Icon size
                      color: Colors.white, // Icon color
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space below icon
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Text(
                    'Waiting for API connection...', // Main message
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold, // Bold text
                          color: Colors.white, // Text color
                        ),
                    textAlign: TextAlign.center, // Centered text
                  ),
                ),
                const SizedBox(height: 16), // Space below message
                const Text(
                  'Weather data will update automatically when the API is connected.', // Sub-message
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey), // Sub-message style
                  textAlign: TextAlign.center, // Centered text
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
