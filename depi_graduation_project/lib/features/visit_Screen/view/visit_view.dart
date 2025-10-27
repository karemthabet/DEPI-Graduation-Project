import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'package:whatsapp/features/visit_Screen/widget/visit_card.dart';

class VisitedView extends StatefulWidget {
  VisitedView({Key? key}) : super(key: key);
  @override
  _VisitedViewState createState() => _VisitedViewState();
}

class _VisitedViewState extends State<VisitedView> {
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();
  ScrollController _scrollController = ScrollController();
  List<bool> visitCompleted = [true, false, false];
  
  DateTime startDate = DateTime.now().subtract(Duration(days: 180));

  // Generate dates dynamically (2 years = 730 days)
  List<DateTime> getAllDays() {
    return List.generate(730, (i) => startDate.add(Duration(days: i)));
  }

  String getMonthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
                   'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  String getDayName(int weekday) {
    const days = ['Wed', 'Thu', 'Fri', 'Sat', 'Sun', 'Mon', 'Tue'];
    return days[weekday % 7];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        180 * 56,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final allDays = getAllDays(); 
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Visit List',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.black
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black , size: 28),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${getMonthName(selectedDate.month)}, ${selectedDate.year}',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color:AppColors.black
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 70.h,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: allDays.length,
              itemBuilder: (context, index) {
                DateTime date = allDays[index];
                bool isSelected = date.day == selectedDate.day && 
                                 date.month == selectedDate.month &&
                                 date.year == selectedDate.year;
                
                return GestureDetector(
                  onTap: () => setState(() {
                    selectedDate = date;
                    if (date.month != currentMonth.month) {
                      currentMonth = DateTime(date.year, date.month);
                    }
                  }),
                  child: Container(
                    width: 48,
                    height: 64,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.starColor : AppColors.normalDaycolor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${date.day}',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Color(0xFF000000),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          getDayName(date.weekday),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: isSelected ? Colors.white : Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Today Visits',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                bool isCompleted = visitCompleted[index];
                bool isLast = index == 2;
                
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              visitCompleted[index] = !visitCompleted[index];
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted ? Color(0xFF4CAF50) : Colors.white,
                              border: Border.all(
                                color: isCompleted ? Color(0xFF4CAF50) : Color(0xFFE0E0E0),
                                width: 2,
                              ),
                            ),
                            child: isCompleted 
                              ? Icon(Icons.check, color: Colors.white, size: 16)
                              : null,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 120,
                            color: Color(0xFFE0E0E0),
                          ),
                      ],
                    ),
                    SizedBox(width: 12),
                    // Card
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: VisitedCard(),
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}