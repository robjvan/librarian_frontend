import 'package:librarian_frontend/models/models.dart';

class GlobalAppState {
  final SettingsStateRepository userSettings;
  final LoadingStatus loadingStatus;

  GlobalAppState({
    required this.userSettings,
    required this.loadingStatus,
  });

  GlobalAppState.initialState()
      : userSettings = SettingsStateRepository.createEmpty(),
        loadingStatus = LoadingStatus.idle;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is GlobalAppState &&
          other.userSettings == userSettings &&
          other.loadingStatus == loadingStatus;

  @override
  int get hashCode => userSettings.hashCode ^ loadingStatus.hashCode;

  GlobalAppState copyWith({
    final SettingsStateRepository? userSettings,
    final LoadingStatus? loadingStatus,
  }) =>
      GlobalAppState(
        userSettings: userSettings ?? this.userSettings,
        loadingStatus: loadingStatus ?? this.loadingStatus,
      );

  GlobalAppState.fromJson(final Map<String, dynamic> json)
      : userSettings = SettingsStateRepository.fromJson(json['userSettings']),
        loadingStatus = LoadingStatus.idle;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'userSettings': userSettings};
}
