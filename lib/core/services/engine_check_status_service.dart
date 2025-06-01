import 'dart:async';

import 'package:engine/lib.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class EngineCheckStatusService extends EngineBaseService {
  late final InternetConnection _internetConnectionChecker;
  late final Timer _timer;
  final hasConnection = true.obs;
  final hasInternetConnection = true.obs;
  @override
  void onInit() {
    _internetConnectionChecker = InternetConnection();

    _timer = Timer.periodic(5.seconds, (final timer) async {
      final hasInternet = await _internetConnectionChecker.hasInternetAccess;
      hasInternetConnection(hasInternet);
    });
    _internetConnectionChecker.onStatusChange.listen((final status) {
      hasConnection(status == InternetStatus.connected);
    });
    super.onInit();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
