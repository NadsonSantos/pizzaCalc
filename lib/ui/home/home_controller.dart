import 'package:get/get.dart';

import '../../core/database/database_helper.dart';
import '../../modules/catalog/repositories/catalog_repository.dart';
import '../../modules/order/models/draft_summary.dart';
import '../../modules/order/repositories/draft_repository.dart';

class HomeController extends GetxController {
  final drafts = <DraftSummary>[].obs;
  final isLoading = true.obs;

  late final DraftRepository _draftRepo;

  @override
  void onInit() {
    super.onInit();
    final catalog = CatalogRepository(DatabaseHelper.instance);
    _draftRepo = DraftRepository(DatabaseHelper.instance, catalog);
    loadDrafts();
  }

  Future<void> loadDrafts() async {
    isLoading.value = true;
    try {
      drafts.assignAll(await _draftRepo.listSummaries());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDraft(int id) async {
    await _draftRepo.deleteDraft(id);
    await loadDrafts();
  }
}
