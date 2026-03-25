import 'dart:convert';

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    this.level = 1,
    this.xp = 0,
    this.streak = 0,
  }) : assert(level > 0, 'Level must be at least 1'),
       assert(xp >= 0, 'XP cannot be negative'),
       assert(streak >= 0, 'Streak cannot be negative');

  final String id;
  final String name;
  final int level;
  final int xp;
  final int streak;

  UserModel copyWith({
    String? id,
    String? name,
    int? level,
    int? xp,
    int? streak,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'level': level,
      'xp': xp,
      'streak': streak,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      level: (map['level'] as num?)?.toInt() ?? 1,
      xp: (map['xp'] as num?)?.toInt() ?? 0,
      streak: (map['streak'] as num?)?.toInt() ?? 0,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, level: $level, xp: $xp, streak: $streak)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.level == level &&
        other.xp == xp &&
        other.streak == streak;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, level, xp, streak);
  }
}
