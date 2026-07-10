import 'package:get/get.dart';
import 'package:my_guide_app/models/tab_model.dart';
import 'package:my_guide_app/models/ad_model.dart';
import 'package:my_guide_app/repositories/abstract/i_tab_repository.dart';
import 'package:my_guide_app/repositories/abstract/i_ad_repository.dart';
import 'package:my_guide_app/core/services/connectivity_service.dart';

class HomeController extends GetxController {
  final ITabRepository _tabRepository = Get.find();
  final IAdRepository _adRepository = Get.find();
  final ConnectivityService _connectivity = Get.find();

  final RxList<TabModel> tabs = <TabModel>[].obs;
  final RxList<AdModel> ads = <AdModel>[].obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTabsAndAds();
  }

  Future<void> loadTabsAndAds() async {
    isLoading.value = true;
    tabs.value = await _tabRepository.getCachedTabs();
    ads.value = await _adRepository.getCachedAds();

    if (await _connectivity.isConnected()) {
      _tabRepository.getTabsStream().listen((newTabs) {
        if (newTabs.isNotEmpty) {
          tabs.value = newTabs;
          _tabRepository.cacheTabs(newTabs);
        }
      });
      _adRepository.getAdsStream().listen((newAds) {
        if (newAds.isNotEmpty) {
          ads.value = newAds;
          _adRepository.cacheAds(newAds);
        }
      });
    }
    isLoading.value = false;
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
