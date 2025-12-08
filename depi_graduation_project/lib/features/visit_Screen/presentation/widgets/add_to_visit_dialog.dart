import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
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
  final DateTime _focusedDay = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  int _selectedHour = 11;
  int _selectedMinute = 30;
  String _selectedPeriod = 'AM';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFFFF9DB),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _addToVisitList();
                      },
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
    // Check if user is guest
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

    final formattedDate = _selectedDate;
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
