class GroupMember {
  final String id;
  final String name;
  final String role;
  final String email;
  final String phone;

  GroupMember({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
