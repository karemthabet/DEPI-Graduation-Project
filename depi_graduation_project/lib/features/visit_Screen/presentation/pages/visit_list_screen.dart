import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../data/model/visit_date.dart';
import '../cubit/visit_cubit.dart';
import '../cubit/visit_state.dart';
import '../widgets/calendar_strip.dart';
import '../widgets/visit_timeline_card.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';

class VisitListScreen extends StatefulWidget {
  const VisitListScreen({super.key});

  @override
  State<VisitListScreen> createState() => _VisitListScreenState();
}

class _VisitListScreenState extends State<VisitListScreen> {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VisitCubit>()..loadVisits(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Visit List',
            style: TextStyle(
              color: Color(0xFF2C3E50),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Color(0xFF2C3E50)),
              onPressed: () {
                context.goNamed(RoutesName.homeView);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Calendar Strip
              BlocBuilder<VisitCubit, VisitState>(
                builder: (context, state) {
                  DateTime currentDate = DateTime.now();
                  if (state is VisitLoaded) {
                    currentDate = state.selectedDate;
                  }
                  
                  return CalendarStrip(
                    selectedDate: currentDate,
                    onDateSelected: (date) {
                      context.read<VisitCubit>().selectDate(date);
                    },
                  );
                },
              ),
              
              const SizedBox(height: 20),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Today Visits',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),

              // Visits List
              Expanded(
                child: BlocBuilder<VisitCubit, VisitState>(
                  builder: (context, state) {
                    if (state is VisitLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is VisitError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is VisitLoaded) {
                      if (state.filteredVisits.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event_busy, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('No visits planned for this day'),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.filteredVisits.length,
                        itemBuilder: (context, index) {
                          final visit = state.filteredVisits[index];
                          return VisitTimelineCard(
                            visit: visit,
                            isLast: index == state.filteredVisits.length - 1,
                            onDelete: () {
                              context.read<VisitCubit>().deleteVisit(visit.id);
                            },
                            onStatusChanged: (val) {
                              context.read<VisitCubit>().toggleCompletion(visit.id, val ?? false);
                            },
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
        
      ),
    );
  }
}
