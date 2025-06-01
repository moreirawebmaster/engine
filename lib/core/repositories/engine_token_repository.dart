import 'dart:convert';

import 'package:engine/lib.dart';

class EngineTokenRepository extends EngineBaseRepository implements IEngineTokenRepository {
  EngineTokenRepository({super.autoAuthorization = false});

  @override
  void onInit() {
    EngineLog.debug('EngineTokenRepository has been initialized');
    super.onInit();
  }

  @override
  Future<EngineResult<String, EngineTokenResponseDto>> connect(final EngineTokenRequestDto dto) async {
    final response = await post<EngineTokenResponseDto>(
      EngineAppSettings().tokenApiUrl,
      {
        'data': dto.toMap(),
      },
      decoder: (final e) => EngineTokenResponseDto.fromMap(e),
    );

    return makeResponse(response);
  }

  @override
  Future<EngineResult<String, EngineTokenResponseDto>> refreshToken(final EngineRefreshTokenRequestDto dto) async {
    final response = await post(
      EngineAppSettings().refreshTokenApiUrl,
      jsonEncode({
        'data': dto.toMap(),
      }),
      decoder: (final e) => EngineTokenResponseDto.fromMap(e),
    );

    return makeResponse(response);
  }

  EngineResult<L, R> makeResponse<L, R>(final EngineHttpResponse<R> response) {
    if (!response.isOk) {
      return Failure((response.bodyString ?? '') as L);
    }

    return Successful(response.body as R);
  }
}
