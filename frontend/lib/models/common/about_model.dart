class AboutModel {
  final String presentation;
  final String studentsCount;
  final String teachersCount;
  final String partnersCount;
  final String labsCount;
  final List<String> departments;
  final String address;
  final String phone;
  final String website;

  AboutModel({
    required this.presentation,
    required this.studentsCount,
    required this.teachersCount,
    required this.partnersCount,
    required this.labsCount,
    required this.departments,
    required this.address,
    required this.phone,
    required this.website,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      presentation: json['presentation'] ?? '',
      studentsCount: json['studentsCount'] ?? '0',
      teachersCount: json['teachersCount'] ?? '0',
      partnersCount: json['partnersCount'] ?? '0',
      labsCount: json['labsCount'] ?? '0',
      departments: List<String>.from(json['departments'] ?? []),
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
    );
  }
}
