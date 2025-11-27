import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarStrip extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const CalendarStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final days = List.generate(30, (index) {
      return DateTime.now().add(Duration(days: index));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            DateFormat('MMMM, yyyy').format(selectedDate),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: days.length,
            itemBuilder: (context, index) {
              // Normalize date to start of day for comparison
              final date = days[index];
              final normalizedCurrent = DateTime(date.year, date.month, date.day);
              final normalizedSelected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
              
              final isSelected = normalizedCurrent.isAtSameMomentAs(normalizedSelected);
              
              return GestureDetector(
                onTap: () {
                  print('CalendarStrip: Tapped date $normalizedCurrent');
                  onDateSelected(date);
                },
                child: Container(
                  width: 50, // Slightly narrower
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFC107) : const Color(0xFFE0E6EB).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20), 
                    
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black : const Color(0xFF546E7A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('E').format(date),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.black : const Color(0xFF78909C),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
