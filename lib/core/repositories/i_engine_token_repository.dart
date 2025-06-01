import 'package:engine/lib.dart';

abstract class IEngineTokenRepository {
  Future<EngineResult<String, EngineTokenResponseDto>> connect(final EngineTokenRequestDto dto);
  Future<EngineResult<String, EngineTokenResponseDto>> refreshToken(final EngineRefreshTokenRequestDto dto);
}
