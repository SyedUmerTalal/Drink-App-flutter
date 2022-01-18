import 'package:drink/utility/strings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:uuid/uuid.dart';

class GooglePlacesRepository {
  GooglePlacesRepository();

  final GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: AppStrings.PLACES_API_KEY);
  final String sessionToken = Uuid().v4();

  Future<PlacesAutocompleteResponse> autoCompleteSearch(
    String searchTerm,
    Position currentPosition,
  ) async {
    return await _places.autocomplete(
      searchTerm,
      sessionToken: sessionToken,
      location: Location(
          lat: currentPosition.latitude, lng: currentPosition.longitude),
      radius: 50,
    );
  }

  Future<PlacesDetailsResponse> placeDetails(Prediction prediction) async {
    final PlacesDetailsResponse response = await _places.getDetailsByPlaceId(
      prediction.placeId,
      sessionToken: sessionToken,
    );
    return response;
  }
}
