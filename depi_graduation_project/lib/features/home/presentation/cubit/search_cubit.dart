import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:whatsapp/features/home/data/repositories/search_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository repo;
  Timer? _debounce;

  SearchCubit(this.repo) : super(SearchInitial());

  void search(String query) {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      emit(SearchLoading());

      // Check internet
      final connectivity = await Connectivity().checkConnectivity();
      final bool offline = connectivity == ConnectivityResult.none;

      if (offline) {
        // Cache will handle it if exists; repo.search already checks cache
        final cached = await repo.search(query);
        emit(SearchSuccess(cached));
        return;
      }

      final predictions = await repo.search(query);
      emit(SearchSuccess(predictions));
    });
  }
}
