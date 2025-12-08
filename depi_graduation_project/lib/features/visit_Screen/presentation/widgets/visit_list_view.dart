import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/visit_items.dart';
import 'visit_timeline_card.dart';
import 'package:whatsapp/l10n/app_localizations.dart';

class VisitListView extends StatelessWidget {
  final List<VisitItem> visits;
  final Function(int) onDelete;
  final Function(int, bool) onStatusChanged;
  final Function(int, String) onTimeEdited;

  const VisitListView({
    super.key,
    required this.visits,
    required this.onDelete,
    required this.onStatusChanged,
    required this.onTimeEdited,
  });

  @override
  Widget build(BuildContext context) {
    if (visits.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today, size: 60.sp, color: Colors.grey[300]),
              SizedBox(height: 16.h),
              Text(
                AppLocalizations.of(context)!.noVisitsForDay,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: visits.length,
        itemBuilder: (context, index) {
          final visit = visits[index];
          return VisitTimelineCard(
            visit: visit,
            isLast: index == visits.length - 1,
            onDelete: () => onDelete(visit.id),
            onStatusChanged: (val) => onStatusChanged(visit.id, val ?? false),
            onTimeEdited: (newTime) => onTimeEdited(visit.id, newTime),
          );
        },
      ),
    );
  }
}
