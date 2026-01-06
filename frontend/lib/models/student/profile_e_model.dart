class ProfileModel {
  final String email;
  final String phone;
  final String address;
  final String birthDate;

  ProfileModel({
    required this.email,
    required this.phone,
    required this.address,
    required this.birthDate,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      birthDate: json['birthDate'] ?? '',
    );
  }
}