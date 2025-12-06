import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../cubit/visit_cubit.dart';
import '../cubit/visit_state.dart';
import '../widgets/visit_timeline_card.dart';

class VisitListScreen extends StatefulWidget {
  const VisitListScreen({super.key});

  @override
  State<VisitListScreen> createState() => _VisitListScreenState();
}

class _VisitListScreenState extends State<VisitListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<VisitCubit>().loadVisits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Visit List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<VisitCubit, VisitState>(
        builder: (context, state) {
          if (state is VisitLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VisitError) {
            return Center(child: Text(state.message));
          } else if (state is VisitLoaded) {
            final selectedDate = state.selectedDate;
            final visits = state.filteredVisits;

            return Column(
              children: [
                // Date Selector Strip
                Container(
                  height: 80.h,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  color: Colors.white,
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 30, // Show next 30 days for example
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final date = DateTime.now().add(Duration(days: index));
                      final isSelected =
                          DateFormat('yyyy-MM-dd').format(date) ==
                          DateFormat('yyyy-MM-dd').format(selectedDate);

                      return GestureDetector(
                        onTap: () {
                          context.read<VisitCubit>().selectDate(date);
                        },
                        child: Container(
                          width: 60.w,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFFFCD34D)
                                    : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12.r),
                            border:
                                isSelected
                                    ? Border.all(color: Colors.orange, width: 2)
                                    : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('MMM').format(date),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color:
                                      isSelected ? Colors.black : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                date.day.toString(),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color:
                                      isSelected
                                          ? Colors.black
                                          : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('E').format(date),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color:
                                      isSelected ? Colors.black : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Divider(),

                // Visits List
                Expanded(
                  child:
                      visits.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 60.sp,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'No visits for this day',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            padding: EdgeInsets.all(16.w),
                            itemCount: visits.length,
                            itemBuilder: (context, index) {
                              final visit = visits[index];
                              return VisitTimelineCard(
                                visit: visit,
                                isLast: index == visits.length - 1,
                                onDelete: () {
                                  context.read<VisitCubit>().deleteVisit(
                                    visit.id,
                                  );
                                },
                                onStatusChanged: (val) {
                                  context.read<VisitCubit>().toggleCompletion(
                                    visit.id,
                                    val ?? false,
                                  );
                                },
                              );
                            },
                          ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
