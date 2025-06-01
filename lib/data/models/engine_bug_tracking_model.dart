class EngineBugTrackingModel {
  EngineBugTrackingModel({
    required this.crashlyticsEnabled,
  });

  final bool crashlyticsEnabled;
}

class EngineBugTrackingModelDefault implements EngineBugTrackingModel {
  @override
  final bool crashlyticsEnabled = false;
}
