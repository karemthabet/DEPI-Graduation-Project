import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whatsapp/core/helper/app_logger.dart';
import 'package:whatsapp/core/helper/app_snack_bar.dart';
import '../../data/model/place__model.dart';
import '../cubit/visit_cubit.dart';
import 'package:whatsapp/l10n/app_localizations.dart';
import '../../../../core/services/network_checker.dart';

class AddToVisitDialog extends StatefulWidget {
  final Place place;

  const AddToVisitDialog({super.key, required this.place});

  @override
  State<AddToVisitDialog> createState() => _AddToVisitDialogState();
}

class _AddToVisitDialogState extends State<AddToVisitDialog> {
  late final ValueNotifier<DateTime> _selectedDateNotifier;
  late final ValueNotifier<DateTime> _displayedMonthNotifier;

  int _selectedHour = 11;
  int _selectedMinute = 30;
  String _selectedPeriod = 'AM';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDateNotifier = ValueNotifier<DateTime>(now);
    _displayedMonthNotifier =
        ValueNotifier<DateTime>(DateTime(now.year, now.month));
  }

  @override
  void dispose() {
    _selectedDateNotifier.dispose();
    _displayedMonthNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    AppLogger.info('All Screen Rebuild');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFFFF9DB),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.9,
              maxHeight: size.height * 0.85,
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      AppLocalizations.of(context)!.addToVisitList,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),

                    // Date Label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.date,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Custom Calendar
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: _buildCustomCalendar(),
                    ),

                    SizedBox(height: 20.h),

                    // Time Label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.time,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Time Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown<int>(
                            value: _selectedHour,
                            items: List.generate(12, (index) => index + 1),
                            onChanged: (val) =>
                                setState(() => _selectedHour = val!),
                            width: 80.w,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          ':',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _buildDropdown<int>(
                            value: _selectedMinute,
                            items: List.generate(60, (index) => index),
                            onChanged: (val) =>
                                setState(() => _selectedMinute = val!),
                            width: 80.w,
                            itemLabel: (val) => val.toString().padLeft(2, '0'),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        _buildPeriodSelector(),
                      ],
                    ),

                    SizedBox(height: 30.h),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _addToVisitList(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFCD34D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.add,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: const BorderSide(color: Colors.black54),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomCalendar() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _displayedMonthNotifier,
      builder: (context, displayedMonth, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Month/Year Header with navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    _displayedMonthNotifier.value = DateTime(
                      displayedMonth.year,
                      displayedMonth.month - 1,
                    );
                  },
                ),
                Text(
                  _getMonthYearText(displayedMonth),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    _displayedMonthNotifier.value = DateTime(
                      displayedMonth.year,
                      displayedMonth.month + 1,
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Weekday headers
            Row(
              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 8.h),

            // Calendar grid
            ValueListenableBuilder<DateTime>(
              valueListenable: _selectedDateNotifier,
              builder: (context, selectedDate, _) {
                return _buildCalendarGrid(displayedMonth, selectedDate);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalendarGrid(DateTime displayedMonth, DateTime selectedDate) {
    final firstDayOfMonth =
        DateTime(displayedMonth.year, displayedMonth.month, 1);
    final lastDayOfMonth =
        DateTime(displayedMonth.year, displayedMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday
    final daysInMonth = lastDayOfMonth.day;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final List<Widget> dayWidgets = [];

    // Empty cells before first day
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(Expanded(child: SizedBox(height: 40.h)));
    }

    // Day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(displayedMonth.year, displayedMonth.month, day);
      final isSelected = date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day;
      final isToday = date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
      final isPast = date.isBefore(today);

      dayWidgets.add(
        Expanded(
          child: GestureDetector(
            onTap: isPast
                ? null
                : () {
                    AppLogger.log(date.toString());
                    _selectedDateNotifier.value = date;
                  },
            child: Container(
              height: 40.h,
              margin: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFCD34D) // اللون الأصفر للمختار
                    : isToday
                        ? const Color(0xFFFDE68A) // أصفر فاتح لليوم الحالي
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isToday && !isSelected
                    ? Border.all(color: const Color(0xFFFCD34D), width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected || isToday
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isPast
                        ? Colors.black26
                        : isSelected
                            ? Colors.black
                            : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Organize into rows
    final List<Widget> rows = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      rows.add(
        Row(
          children: dayWidgets.sublist(
            i,
            i + 7 > dayWidgets.length ? dayWidgets.length : i + 7,
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  String _getMonthYearText(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required double width,
    String Function(T)? itemLabel,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE68A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          isExpanded: true,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Center(
                child: Text(
                  itemLabel != null ? itemLabel(item) : item.toString(),
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _periodButton('AM'),
          _periodButton('PM'),
        ],
      ),
    );
  }

  Widget _periodButton(String period) {
    final bool isSelected = _selectedPeriod == period;
    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = period),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFCD34D) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          period,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.black54,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }

  Future<void> _addToVisitList() async {
    final storage = GetStorage();
    final bool isGuest = storage.read('isGuest') ?? false;

    if (isGuest) {
      if (!mounted) return;
      Navigator.pop(context);
      AppSnackBar.warning(context, 'Please login to add to visit list');
      return;
    }

    final hasInternet = await NetworkChecker.instance.isConnected();
    if (!mounted) return;

    if (!hasInternet) {
      AppSnackBar.warning(context, 'No internet connection');
      return;
    }

    final formattedDate = _selectedDateNotifier.value;
    final timeString =
        "${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} $_selectedPeriod";

    if (!mounted) return;
    context.read<VisitCubit>().addVisit(
          place: widget.place,
          visitDate: formattedDate,
          visitTime: timeString,
        );

    Navigator.pop(context);
    AppSnackBar.success(context, 'Added to visit list');
  }
}
