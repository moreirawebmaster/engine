import 'package:engine/lib.dart';

class EngineTokenService extends EngineBaseService {
  EngineTokenService(this._localStorageRepository, this._tokenRepository);

  final IEngineLocalStorageRepository _localStorageRepository;
  final IEngineTokenRepository _tokenRepository;

  EngineTokenModel _token = EngineTokenModel.empty();
  EngineTokenModel get token => _token;

  @override
  void onInit() {
    final tokenStorage = _localStorageRepository.getObject<EngineTokenModel, Map<String, dynamic>>(
      EngineConstant.tokenKey,
      fromMap: EngineTokenModel.fromMap,
    );

    if (tokenStorage is EngineTokenModel) {
      _token = tokenStorage;
    }

    super.onInit();
  }

  Future<EngineResult<String, EngineTokenResponseDto>> connect({
    required final String email,
    required final String password,
  }) async {
    final dto = EngineTokenRequestDto(
      email: email,
      password: password,
    );

    final result = await _tokenRepository.connect(dto);

    if (result.isSuccessful) {
      _token = EngineTokenModel(
        accessToken: result.data.token,
        refreshToken: result.data.token,
      );
      await _localStorageRepository.setObject(EngineConstant.tokenKey, _token);
    }

    return result;
  }

  //TODO: The backend is not working, so we need to remove this method
  Future<bool> refreshToken() async {
    final dto = EngineRefreshTokenRequestDto(
      email: '',
      refreshToken: token.refreshToken,
      scope: '',
    );

    final result = await _tokenRepository.refreshToken(dto);

    if (result.isSuccessful) {
      _token = EngineTokenModel.fromMap(result.data.toMap());
      await _localStorageRepository.setObject(EngineConstant.tokenKey, _token);
    }

    return result.isSuccessful;
  }

  Future<void> clean() async {
    await _localStorageRepository.removeAll([
      EngineConstant.tokenKey,
      EngineConstant.userKey,
    ]);
    _token = EngineTokenModel.empty();
  }
}
