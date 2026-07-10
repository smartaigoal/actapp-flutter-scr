import 'package:my_guide_app/models/place_model.dart';

abstract class IPlaceRepository {
  Stream<List<PlaceModel>> getPlacesStream({String? categoryId});
  Future<List<PlaceModel>> getCachedPlaces();
  Future<void> cachePlaces(List<PlaceModel> places);
  Future<PlaceModel> addPlace(PlaceModel place, List<String> imageFiles);
  Future<void> updatePlace(PlaceModel place);
  Future<void> deletePlace(String id);
}
