import 'package:engine/lib.dart';

class EngineUserService extends EngineBaseService {
  EngineUserService(this._localStorageRepository);

  final IEngineLocalStorageRepository _localStorageRepository;

  EngineUserModel _user = EngineUserModel.empty();

  EngineUserModel get user => _user;

  @override
  void onInit() {
    _user = _localStorageRepository.getObject<EngineUserModel, EngineMap>(EngineConstant.userKey, fromMap: EngineUserModel.fromMap) ?? EngineUserModel.empty();
    _setBugTrackingUser(_user);
    super.onInit();
  }

  Future<void> save(final EngineUserModel user) async {
    _user = user;
    _setBugTrackingUser(user);
    await _localStorageRepository.setObject<EngineUserModel>(EngineConstant.userKey, user);
  }

  Future<void> clean() async {
    await _localStorageRepository.remove(EngineConstant.userKey);
    _user = EngineUserModel.empty();
  }

  void _setBugTrackingUser(final EngineUserModel user) {
    EngineBugTracking.setUserIdentifier(user.id.toString());
    EngineBugTracking.setCustomKey('email', user.email);
    EngineBugTracking.setCustomKey('name', user.name);
  }
}
