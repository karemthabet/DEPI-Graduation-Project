import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/visit_items.dart';

class VisitTimelineCard extends StatelessWidget {
  final VisitItem visit;
  final bool isLast;
  final VoidCallback onDelete;
  final Function(bool?) onStatusChanged;

  const VisitTimelineCard({
    super.key,
    required this.visit,
    this.isLast = false,
    required this.onDelete,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          SizedBox(
            width: 40.w,
            child: Column(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: visit.isCompleted ? Colors.green : Colors.white,
                    border: Border.all(
                      color: visit.isCompleted ? Colors.green : const Color(0xFFFFC107),
                      width: 2.w,
                    ),
                  ),
                  child: visit.isCompleted
                      ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.w, // Thinner line
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      decoration: const BoxDecoration(
                        color: Colors.grey, // Dashed line effect simulation or just grey
                      ),
                      child: CustomPaint(
                        painter: DashedLinePainter(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          SizedBox(width: 8.w),

          // Card
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0.h),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4), // Light yellow bg
                  borderRadius: BorderRadius.circular(24.r),
                ),
                padding: EdgeInsets.all(16.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.network(
                        visit.imageUrl,
                        width: 90.w,
                        height: 90.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
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
                                          size: 20.sp
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
