import 'package:engine/lib.dart';

class EngineTranslation extends EngineBaseTranslation {
  static const String noInternetConnection = 'ENGINE_NO_INTERNET_CONNECTION';
  static const String noConnection = 'ENGINE_NO_CONNECTION';

  @override
  Map<EngineTranslationTypeEnum, Map<String, String>> get translations => {
        EngineTranslationTypeEnum.en: {
          noInternetConnection: 'No internet connection, you are in offline mode',
          noConnection: 'No connection, you are in offline mode.',
        },
        EngineTranslationTypeEnum.pt: {
          noInternetConnection: 'Sem conexão com a internet, você está em modo offline',
          noConnection: 'Sem conexão, você está em modo offline.',
        },
        EngineTranslationTypeEnum.es: {
          noInternetConnection: 'Sin conexión a internet, estás en modo offline',
          noConnection: 'Sin conexión, estás en modo offline.',
        },
      };
}
