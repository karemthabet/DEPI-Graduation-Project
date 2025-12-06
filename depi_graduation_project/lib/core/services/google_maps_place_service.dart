import 'dart:convert';
import 'package:whatsapp/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:http/http.dart' as http;
import 'package:whatsapp/models/places_details_model/places_details_model.dart';

class GoogleMapsPlaceServic {
  final String baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final String apikey = 'AIzaSyA3FifUzz1TsB2bknK0VARH_45PT_AuyMw';

  Future<List<PlaceAutocompleteModel>> getpredictions({
    required String input,
    required String sessiontoken,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/autocomplete/json?key=$apikey&input=$input&sessiontoken=$sessiontoken&components=country:eg',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['predictions'];
      final List<PlaceAutocompleteModel> places = [];

      for (var item in data) {
        places.add(PlaceAutocompleteModel.fromJson(item));
      }
      return places;
    } else {
      throw Exception();
    }
  }

  Future<PlacesDetailsModel> getPlaceDetails({required String placeId}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/details/json?key=$apikey&place_id=$placeId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['result'];

      return PlacesDetailsModel.fromJson(data);
    } else {
      throw Exception();
    }
  }
}
