import 'package:whatsapp/models/place_autocomplete_model/place_autocomplete_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<PlaceAutocompleteModel> places;
  SearchSuccess(this.places);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
