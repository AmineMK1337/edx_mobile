class SettingsModel {
  final String userName;
  final String userPhone;
  final bool pushNotifications;
  final bool gradeAlerts;
  final bool messageAlerts;
  final bool absenceAlerts;
  final bool isDarkMode;
  final String currentLanguage;
  final String passwordLastChanged;

  SettingsModel({
    required this.userName,
    required this.userPhone,
    required this.pushNotifications,
    required this.gradeAlerts,
    required this.messageAlerts,
    required this.absenceAlerts,
    required this.isDarkMode,
    required this.currentLanguage,
    required this.passwordLastChanged,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      userName: json['userName'] ?? '',
      userPhone: json['userPhone'] ?? '',
      pushNotifications: json['pushNotifications'] ?? true,
      gradeAlerts: json['gradeAlerts'] ?? true,
      messageAlerts: json['messageAlerts'] ?? true,
      absenceAlerts: json['absenceAlerts'] ?? false,
      isDarkMode: json['isDarkMode'] ?? false,
      currentLanguage: json['currentLanguage'] ?? 'Français',
      passwordLastChanged: json['passwordLastChanged'] ?? '',
    );
  }

  SettingsModel copyWith({
    String? userName,
    String? userPhone,
    bool? pushNotifications,
    bool? gradeAlerts,
    bool? messageAlerts,
    bool? absenceAlerts,
    bool? isDarkMode,
    String? currentLanguage,
    String? passwordLastChanged,
  }) {
    return SettingsModel(
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      gradeAlerts: gradeAlerts ?? this.gradeAlerts,
      messageAlerts: messageAlerts ?? this.messageAlerts,
      absenceAlerts: absenceAlerts ?? this.absenceAlerts,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      passwordLastChanged: passwordLastChanged ?? this.passwordLastChanged,
    );
  }
}
