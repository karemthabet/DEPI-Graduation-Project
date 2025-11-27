import 'package:flutter/material.dart';
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
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: visit.isCompleted ? Colors.green : Colors.white,
                    border: Border.all(
                      color: visit.isCompleted ? Colors.green : const Color(0xFFFFC107),
                      width: 2,
                    ),
                  ),
                  child: visit.isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1, // Thinner line
                      margin: const EdgeInsets.symmetric(vertical: 4),
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
          
          const SizedBox(width: 8),

          // Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4), // Light yellow bg
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        visit.imageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              width: 90,
                              height: 90,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
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
                                  const Icon(Icons.access_time, size: 14, color: Color(0xFF2C3E50)),
                                  const SizedBox(width: 4),
                                  Text(
                                    visit.visitTime ?? 'Anytime',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF2C3E50),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              PopupMenuButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.more_vert, size: 20, color: Color(0xFF2C3E50)),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    onTap: onDelete,
                                    child: const Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red, size: 20),
                                        SizedBox(width: 8),
                                        Text('Delete'),
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
                                          size: 20
                                        ),
                                        const SizedBox(width: 8),
                                        Text(visit.isCompleted ? 'Mark Undone' : 'Mark Done'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            visit.placeName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF102A43),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                visit.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF486581),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.star, size: 14, color: Colors.amber),
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
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 1;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
