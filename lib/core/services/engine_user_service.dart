import 'package:engine/lib.dart';

class EngineUserService extends EngineBaseService {
  EngineUserService(this._localStorageRepository);

  final IEngineLocalStorageRepository _localStorageRepository;

  EngineUserModel _user = EngineUserModel.empty();

  EngineUserModel get user => _user;

  @override
  void onInit() {
    _user = _localStorageRepository.getObject<EngineUserModel, EngineMap>(EngineConstant.userKey, fromMap: EngineUserModel.fromMap) ?? EngineUserModel.empty();
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    await _setBugTrackingUser(_user);
    super.onReady();
  }

  Future<void> save(final EngineUserModel user) async {
    _user = user;
    await Future.wait([
      _setBugTrackingUser(user),
      _localStorageRepository.setObject<EngineUserModel>(EngineConstant.userKey, user),
    ]);
  }

  Future<void> clean() async {
    await _localStorageRepository.remove(EngineConstant.userKey);
    _user = EngineUserModel.empty();
  }

  Future<void> _setBugTrackingUser(final EngineUserModel user) async {
    await Future.wait([
      EngineBugTracking.setUserIdentifier(user.id.toString()),
      EngineBugTracking.setCustomKey('email', user.email),
      EngineBugTracking.setCustomKey('name', user.name),
    ]);
  }
}
