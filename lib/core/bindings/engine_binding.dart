import 'package:engine/lib.dart';
import 'package:get_storage/get_storage.dart';

/// A binding that register the local storage repository and CoreApp.
///
/// The [dependencies] method is overridden to register the local storage
class EngineBinding extends EngineBaseBinding {
  @override
  void dependencies() {
    register
      ..lazyPut<IEngineTokenRepository>(EngineTokenRepository.new)
      ..lazyPut<EngineCheckStatusService>(() => EngineCheckStatusService())
      ..lazyPut<EngineTokenService>(() => EngineTokenService(register.find(), register.find()))
      ..lazyPut<EngineUserService>(() => EngineUserService(register.find()))
      ..lazyPut<EngineNavigationService>(() => EngineNavigationService())
      ..lazyPut<EngineLocaleService>(() => EngineLocaleService())
      ..lazyPut<EngineAnalyticsService>(() => EngineAnalyticsService());
  }

  /// Initializes the local storage repository.
  ///
  /// This method is used to initialize the local storage repository with the
  /// given [storageName].
  ///
  /// The [storageName] parameter is optional and defaults to [IEngineLocalStorageRepository.storageName].
  ///
  /// This method returns a [Future] that completes when the local storage
  /// repository is initialized.
  static Future<void> initStorage({final String storageName = IEngineLocalStorageRepository.storageName}) async {
    await EngineCoreDependency.instance.putAsync<IEngineLocalStorageRepository>(() async {
      await GetStorage.init(storageName);
      return LocalStorageGetStorageRepository(GetStorage(storageName));
    }, permanent: true);
  }
}
