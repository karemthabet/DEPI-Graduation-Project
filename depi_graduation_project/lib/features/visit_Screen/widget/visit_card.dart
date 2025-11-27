import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';

class VisitedCard extends StatefulWidget {
  const VisitedCard({super.key});

  @override
  State<VisitedCard> createState() => _VisitedCardState();
}

class _VisitedCardState extends State<VisitedCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9CF),
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/places1.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.image, color: Colors.grey[600]),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          // Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Time
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Color(0xFF243E4B),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '10:00',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF243E4B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Place Name
                Text(
                  'Al-Azhar Park',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF243E4B),
                  ),
                ),
                const SizedBox(height: 8),
                // Rating
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.starColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '4.9',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF243E4B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // More button
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              size: 24,
              color: Color(0xFF243E4B),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
