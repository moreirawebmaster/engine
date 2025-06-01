import 'package:engine/lib.dart';
import 'package:get/get.dart';

abstract class EngineBaseAppTranslation extends Translations {}

abstract class EngineBaseTranslation extends Translations {
  Map<EngineTranslationTypeEnum, Map<String, String>> get translations;

  @override
  Map<String, Map<String, String>> get keys => translations.map(
        (final key, final value) => MapEntry(key.name, value),
      );
}
