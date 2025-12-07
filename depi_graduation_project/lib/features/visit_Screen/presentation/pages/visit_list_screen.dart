import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/visit_cubit.dart';
import '../cubit/visit_state.dart';
import '../widgets/visit_date_selector.dart';
import '../widgets/visit_list_view.dart';

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
    context.read<VisitCubit>().loadVisits(showLoading: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Visit List",
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
            return Center(child: Text(state.failure.errMessage));
          } else if (state is VisitLoaded) {
            final selectedDate = state.selectedDate;
            final visits = state.filteredVisits;

            return Column(
              children: [
                VisitDateSelector(
                  selectedDate: selectedDate,
                  scrollController: _scrollController,
                  onDateSelected: (date) {
                    context.read<VisitCubit>().selectDate(date);
                  },
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Today Visits",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ),
                ),

                VisitListView(
                  visits: visits,
                  onDelete: (id) {
                    context.read<VisitCubit>().deleteVisit(id);
                  },
                  onStatusChanged: (id, isCompleted) {
                    context.read<VisitCubit>().toggleCompletion(id, isCompleted);
                  },
                  onTimeEdited: (id, newTime) {
                    context.read<VisitCubit>().updateTime(id, newTime);
                  },
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
