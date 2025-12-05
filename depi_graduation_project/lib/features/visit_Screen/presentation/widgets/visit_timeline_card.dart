import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/features/visit_Screen/data/model/visit_items.dart';

class VisitTimelineCard extends StatelessWidget {
  final VisitItem visit;
  final bool isLast;
  final VoidCallback onDelete;
  final Function(bool?) onStatusChanged;

  const VisitTimelineCard({
    super.key,
    required this.visit,
    required this.isLast,
    required this.onDelete,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line
          Column(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFCD34D),
                  border: Border.all(color: Colors.orange, width: 2),
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
          
          // Card Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Image
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

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 14.sp, color: const Color(0xFF2C3E50)),
                                SizedBox(width: 4.w),
                                Text(
                                  visit.visitTime ?? 'Anytime',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF2C3E50),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            PopupMenuButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(Icons.more_vert, size: 20.sp, color: const Color(0xFF2C3E50)),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: onDelete,
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red, size: 20.sp),
                                      SizedBox(width: 8.w),
                                      Text('Delete', style: TextStyle(fontSize: 14.sp)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  onTap: () => onStatusChanged(!visit.isCompleted),
                                  child: Row(
                                    children: [
                                      Icon(
                                        visit.isCompleted ? Icons.close : Icons.check,
                                        color: Colors.green,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(visit.isCompleted ? 'Mark Undone' : 'Mark Done', style: TextStyle(fontSize: 14.sp)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          visit.placeName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF102A43),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(
                              visit.rating.toString(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF486581),
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
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5.h, dashSpace = 3.h, startY = 0;
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 1.w;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
