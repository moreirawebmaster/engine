class EngineFirebaseModel {
  EngineFirebaseModel({
    required this.name,
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    this.authDomain,
    this.databaseURL,
    this.storageBucket,
    this.measurementId,
    this.trackingId,
    this.deepLinkURLScheme,
    this.androidClientId,
    this.iosClientId,
    this.iosBundleId,
    this.appGroupId,
  });

  final String name;
  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String? authDomain;
  final String? databaseURL;
  final String? storageBucket;
  final String? measurementId;
  final String? trackingId;
  final String? deepLinkURLScheme;
  final String? androidClientId;
  final String? iosClientId;
  final String? iosBundleId;
  final String? appGroupId;

  factory EngineFirebaseModel.android({
    required final String name,
    required final String apiKey,
    required final String appId,
    required final String messagingSenderId,
    required final String projectId,
    final String? authDomain,
    final String? databaseURL,
    final String? storageBucket,
    final String? measurementId,
    final bool crashlyticsEnabled = true,
  }) =>
      EngineFirebaseModel(
        name: name,
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
      );

  factory EngineFirebaseModel.ios({
    required final String name,
    required final String apiKey,
    required final String appId,
    required final String messagingSenderId,
    required final String projectId,
    final String? authDomain,
    final String? databaseURL,
    final String? storageBucket,
    final String? measurementId,
    final String? trackingId,
    final String? deepLinkURLScheme,
    final String? androidClientId,
    final String? iosClientId,
    final String? iosBundleId,
    final String? appGroupId,
    final bool crashlyticsEnabled = true,
  }) =>
      EngineFirebaseModel(
        name: name,
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        trackingId: trackingId,
        deepLinkURLScheme: deepLinkURLScheme,
        androidClientId: androidClientId,
        iosClientId: iosClientId,
        iosBundleId: iosBundleId,
        appGroupId: appGroupId,
      );
}
