import 'package:get_it/get_it.dart';
import 'package:my_portfolio/modules/resume/core/resume_store.dart';

final getIt = GetIt.instance;

class DI {
  static Future<void> init() async {
    // Register stores
    getIt.registerLazySingleton<ResumeStore>(() => ResumeStore());
  }

  // Getters for stores
  static ResumeStore get resumeStore => getIt<ResumeStore>();
}
