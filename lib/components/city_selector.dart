import 'package:flutter/material.dart';

class CitySelector extends StatelessWidget {
  final int selectedIndex;
  final List<Map<String, dynamic>> weatherDataList;
  final ValueChanged<int?> onCityChanged;
  final VoidCallback onAdd;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Color iconColor;

  const CitySelector({
    super.key,
    required this.selectedIndex,
    required this.weatherDataList,
    required this.onCityChanged,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    this.iconColor = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white.withOpacity(0.98),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: iconColor, width: 2),
                  borderRadius: BorderRadius.circular(14),
                  color: iconColor.withOpacity(0.08),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedIndex,
                    dropdownColor: Colors.white,
                    icon: Icon(Icons.arrow_drop_down_circle, color: iconColor, size: 32),
                    style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 20),
                    onChanged: onCityChanged,
                    items: List.generate(weatherDataList.length, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Row(
                          children: [
                            Icon(Icons.location_city, color: iconColor, size: 22),
                            const SizedBox(width: 8),
                            Text(weatherDataList[index]['city'], style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: onAdd,
                    icon: Icon(Icons.add_circle, color: Colors.greenAccent.shade700),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.greenAccent.shade700,
                      side: BorderSide(color: Colors.greenAccent.shade700, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      elevation: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: weatherDataList.isNotEmpty ? onEdit : null,
                    icon: Icon(Icons.edit, color: Colors.orange.shade700),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.orange.shade700,
                      side: BorderSide(color: Colors.orange.shade700, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      elevation: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: weatherDataList.length > 1 ? onDelete : null,
                    icon: Icon(Icons.delete_forever, color: Colors.redAccent.shade700),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.redAccent.shade700,
                      side: BorderSide(color: Colors.redAccent.shade700, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
