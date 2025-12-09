abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<dynamic> predictions;
  SearchSuccess(this.predictions);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
