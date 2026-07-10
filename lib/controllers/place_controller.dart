import 'package:get/get.dart';
import 'package:my_guide_app/models/place_model.dart';
import 'package:my_guide_app/models/category_model.dart';
import 'package:my_guide_app/repositories/abstract/i_place_repository.dart';
import 'package:my_guide_app/repositories/abstract/i_category_repository.dart';
import 'package:my_guide_app/core/services/location_service.dart';
import 'package:my_guide_app/core/services/connectivity_service.dart';

class PlaceController extends GetxController {
  final IPlaceRepository _placeRepository = Get.find();
  final ICategoryRepository _categoryRepository = Get.find();
  final LocationService _locationService = Get.find();
  final ConnectivityService _connectivity = Get.find();

  final RxList<PlaceModel> places = <PlaceModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedCategoryId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadPlaces();
  }

  Future<void> loadCategories() async {
    categories.value = await _categoryRepository.getCachedCategories();
    if (await _connectivity.isConnected()) {
      _categoryRepository.getCategoriesStream().listen((newCategories) {
        if (newCategories.isNotEmpty) {
          categories.value = newCategories;
          _categoryRepository.cacheCategories(newCategories);
        }
      });
    }
  }

  Future<void> loadPlaces({String? categoryId}) async {
    isLoading.value = true;
    places.value = await _placeRepository.getCachedPlaces();
    if (await _connectivity.isConnected()) {
      _placeRepository.getPlacesStream(categoryId: categoryId).listen((newPlaces) {
        if (newPlaces.isNotEmpty) {
          places.value = newPlaces;
          _placeRepository.cachePlaces(newPlaces);
        }
      });
    }
    isLoading.value = false;
  }
}
