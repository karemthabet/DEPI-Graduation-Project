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
