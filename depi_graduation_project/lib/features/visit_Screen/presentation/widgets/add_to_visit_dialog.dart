import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Assuming screenutil is used
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatsapp/l10n/app_localizations.dart';
import '../../data/model/place__model.dart';
import '../cubit/visit_cubit.dart';

class AddToVisitDialog extends StatefulWidget {
  final Place place;

  const AddToVisitDialog({super.key, required this.place});

  @override
  State<AddToVisitDialog> createState() => _AddToVisitDialogState();
}

class _AddToVisitDialogState extends State<AddToVisitDialog> {
  final DateTime _focusedDay = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  // Time selection
  int _selectedHour = 11;
  int _selectedMinute = 30;
  String _selectedPeriod = 'AM';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFFFF9DB), // Light yellow background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.addToVisitList,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
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

              // Calendar
              Container(
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
                child: CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  onDateChanged: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
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

              // Time Picker Row
              Row(
                children: [
                  _buildDropdown<int>(
                    value: _selectedHour,
                    items: List.generate(12, (index) => index + 1),
                    onChanged: (val) => setState(() => _selectedHour = val!),
                    width: 70.w,
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
                  _buildDropdown<int>(
                    value: _selectedMinute,
                    items: List.generate(60, (index) => index),
                    onChanged: (val) => setState(() => _selectedMinute = val!),
                    width: 70.w,
                    itemLabel: (val) => val.toString().padLeft(2, '0'),
                  ),
                  SizedBox(width: 16.w),
                  _buildPeriodSelector(),
                ],
              ),

              SizedBox(height: 30.h),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _addToVisitList();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFCD34D), // Yellow
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
        color: const Color(0xFFFDE68A), // Light orange/yellow
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
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
        children: [_periodButton('AM'), _periodButton('PM')],
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

  void _addToVisitList() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseLoginFirst)),
      );
      return;
    }

    final formattedDate = _selectedDate;
    final timeString =
        "${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} $_selectedPeriod";

    context.read<VisitCubit>().addVisit(
      place: widget.place,
      visitDate: formattedDate,
      userId: userId,
      visitTime: timeString,
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.addedToVisitList)),
    );
  }
}
