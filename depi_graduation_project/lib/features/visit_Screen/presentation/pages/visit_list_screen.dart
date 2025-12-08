import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/visit_cubit.dart';
import '../cubit/visit_state.dart';
import '../widgets/visit_date_selector.dart';
import '../widgets/visit_list_view.dart';
import 'package:whatsapp/l10n/app_localizations.dart';
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
          AppLocalizations.of(context)!.visitList,
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.orange,
                    size: 60.sp,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    AppLocalizations.of(context)!.noInternetConnection,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () {
                       context.read<VisitCubit>().loadVisits(showLoading: true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3F4F6), 
                      foregroundColor: const Color(0xFF6B7280),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.retry,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
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
                      AppLocalizations.of(context)!.todayVisits,
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
