extension EngineStringExtension on String {
  String get removeSpacesAndLineBreaks => replaceAll(RegExp(r'\s+'), ' ').trim();
}
