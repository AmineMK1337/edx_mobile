class ResultModel {
  final String id;
  final String moduleName;
  final double cc;
  final double exam;
  final int credits;

  ResultModel({
    required this.id,
    required this.moduleName,
    required this.cc,
    required this.exam,
    required this.credits,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      id: json['_id'] ?? '',
      moduleName: json['moduleName'] ?? '',
      cc: (json['cc'] ?? 0).toDouble(),
      exam: (json['exam'] ?? 0).toDouble(),
      credits: json['credits'] ?? 1,
    );
  }

  // Logique métier liée aux données
  double get average => (cc * 0.4) + (exam * 0.6);
  bool get isValidated => average >= 10.0;
}