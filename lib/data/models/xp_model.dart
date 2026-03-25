import 'dart:convert';

class XpModel {
  const XpModel({required this.currentXP, required this.requiredXP})
    : assert(currentXP >= 0, 'Current XP cannot be negative'),
      assert(requiredXP > 0, 'Required XP must be positive');

  final int currentXP;
  final int requiredXP;

  double get progress => (currentXP / requiredXP).clamp(0.0, 1.0);

  XpModel copyWith({int? currentXP, int? requiredXP}) {
    return XpModel(
      currentXP: currentXP ?? this.currentXP,
      requiredXP: requiredXP ?? this.requiredXP,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'currentXP': currentXP, 'requiredXP': requiredXP};
  }

  factory XpModel.fromMap(Map<String, dynamic> map) {
    return XpModel(
      currentXP: (map['currentXP'] as num?)?.toInt() ?? 0,
      requiredXP: (map['requiredXP'] as num?)?.toInt() ?? 100,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory XpModel.fromJson(String source) =>
      XpModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'XpModel(currentXP: $currentXP, requiredXP: $requiredXP)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is XpModel &&
        other.currentXP == currentXP &&
        other.requiredXP == requiredXP;
  }

  @override
  int get hashCode {
    return Object.hash(currentXP, requiredXP);
  }
}
