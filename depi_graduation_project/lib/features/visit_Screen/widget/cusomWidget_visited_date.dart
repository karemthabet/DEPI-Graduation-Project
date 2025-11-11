import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/core/functions/device_size.dart'; 

class DaysSelector extends StatefulWidget {
  final DateTime initialDate;

  const DaysSelector({Key? key, required this.initialDate}) : super(key: key);

  @override
  _DaysSelectorState createState() => _DaysSelectorState();
}

class _DaysSelectorState extends State<DaysSelector> {
  late DateTime selectedDate;
  late DateTime currentMonth;
  late ScrollController _scrollController;
  late List<DateTime> allDays;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    currentMonth = DateTime(selectedDate.year, selectedDate.month);
    _scrollController = ScrollController();
    allDays = _generateDaysForMonth(currentMonth);
  }

  List<DateTime> _generateDaysForMonth(DateTime month) {
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    return List.generate(daysInMonth, (index) => DateTime(month.year, month.month, index + 1));
  }

  String getMonthName(int month) {
    List<String> months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }

  String getDayName(int weekday) {
    List<String> days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight(context) * 0.02), 
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 0.05),
          child: Text(
            '${getMonthName(selectedDate.month)}, ${selectedDate.year}',
            style: GoogleFonts.inter(
              fontSize: screenHeight(context) * 0.022,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: screenHeight(context) * 0.025),
        SizedBox(
          height: screenHeight(context) * 0.09,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 0.03),
            itemCount: allDays.length,
            itemBuilder: (context, index) {
              DateTime date = allDays[index];
              bool isSelected = date.day == selectedDate.day &&
                                date.month == selectedDate.month &&
                                date.year == selectedDate.year;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                    if (date.month != currentMonth.month) {
                      currentMonth = DateTime(date.year, date.month);
                      allDays = _generateDaysForMonth(currentMonth);
                    }
                  });
                },
                child: Container(
                  width: screenWidth(context) * 0.12,
                  height: screenHeight(context) * 0.08,
                  margin: EdgeInsets.only(right: screenWidth(context) * 0.02),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${date.day}',
                        style: GoogleFonts.inter(
                          fontSize: screenHeight(context) * 0.025,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight(context) * 0.005),
                      Text(
                        getDayName(date.weekday),
                        style: GoogleFonts.inter(
                          fontSize: screenHeight(context) * 0.015,
                          fontWeight: FontWeight.w400,
                          color: isSelected ? Colors.white : Colors.grey[600],
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
