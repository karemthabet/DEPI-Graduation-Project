import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/core/utils/time_utils.dart'; // Import TimeUtils
import 'package:whatsapp/features/visit_Screen/data/model/visit_items.dart';
import 'package:whatsapp/l10n/app_localizations.dart';
class VisitTimelineCard extends StatelessWidget {
  final VisitItem visit;
  final bool isLast;
  final VoidCallback onDelete;
  final Function(bool?) onStatusChanged;
  final Function(String) onTimeEdited;

  const VisitTimelineCard({
    super.key,
    required this.visit,
    required this.isLast,
    required this.onDelete,
    required this.onStatusChanged,
    required this.onTimeEdited,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () => onStatusChanged(!visit.isCompleted),
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: visit.isCompleted ? Colors.green : Colors.white,
                    border: Border.all(
                        color: visit.isCompleted ? Colors.green : const Color(0xFFFCD34D),
                        width: 2),
                  ),
                  child: visit.isCompleted
                      ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                      : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: CustomPaint(
                    painter: DashedLinePainter(),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB), 
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: CachedNetworkImage(
                      imageUrl: visit.imageUrl,
                      width: 90.w,
                      height: 90.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 90.w,
                        height: 90.w,
                        color: Colors.grey[200],
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 90.w,
                        height: 90.w,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                               onTap: () => _editTime(context),
                               child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time, size: 14.sp, color: const Color(0xFF1F2937)),
                                    SizedBox(width: 4.w),
                                    Text(
                                      visit.visitTime ?? '00:00',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: const Color(0xFF1F2937),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(Icons.more_vert, size: 20.sp, color: const Color(0xFF1F2937)),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () => Future.delayed(Duration.zero, () => _editTime(context)),
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.blue, size: 20.sp),
                                      SizedBox(width: 8.w),
                                      Text(AppLocalizations.of(context)!.editTime, style: TextStyle(fontSize: 14.sp)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  onTap: () => Future.delayed(Duration.zero, onDelete),
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red, size: 20.sp),
                                      SizedBox(width: 8.w),
                                      Text(AppLocalizations.of(context)!.delete, style: TextStyle(fontSize: 14.sp)),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          visit.placeName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF111827),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              visit.rating.toString(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4B5563),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(Icons.star, size: 14.sp, color: Colors.amber),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final formattedTime = TimeUtils.formatTimeOfDay(picked);
      onTimeEdited(formattedTime);
    }
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5.h, dashSpace = 3.h, startY = 0;
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1.w;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
