import '../models/place_model.dart';

List<PlaceModel> recentSearchPlaces = [
];
void addRecentSearchPlaces(PlaceModel place) {
  // print("Thêm địa điểm $place");
  recentSearchPlaces.add(place);
  recentSearchPlaces.toSet().toList();
  // print(recentSearchPlaces);
}
