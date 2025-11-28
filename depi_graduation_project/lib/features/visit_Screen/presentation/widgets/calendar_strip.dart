import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            DateFormat('MMMM, yyyy').format(selectedDate),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2C3E50),
            ),
          ),
        ),
        SizedBox(
          height: 80.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                  width: 50.w, // Slightly narrower
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFC107) : const Color(0xFFE0E6EB).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20.r), 
                    
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black : const Color(0xFF546E7A),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        DateFormat('E').format(date),
                        style: TextStyle(
                          fontSize: 12.sp,
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
