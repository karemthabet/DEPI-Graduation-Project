import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'package:whatsapp/features/visit_Screen/widget/cusomWidget_visited_date.dart';
import 'package:whatsapp/features/visit_Screen/widget/custom_widget_finished_or_not.dart';
import 'package:whatsapp/features/visit_Screen/widget/visit_card.dart';

class VisitedView extends StatefulWidget {
  const VisitedView({Key? key}) : super(key: key);
  
  @override
  State<VisitedView> createState() => _VisitedViewState();
}

class _VisitedViewState extends State<VisitedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Visit List',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          DaysSelector(initialDate: DateTime(2025, 11, 8)),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Today Visits',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,

                color: AppColors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VisitIndicator(
                      isLast:false,
                      initialCompleted: true,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
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