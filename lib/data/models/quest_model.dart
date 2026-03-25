import 'dart:convert';

enum QuestType { daily, main, side }

class QuestModel {
  const QuestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    this.isCompleted = false,
    this.type = QuestType.side,
  }) : assert(xpReward >= 0, 'XP reward cannot be negative');

  final String id;
  final String title;
  final String description;
  final int xpReward;
  final bool isCompleted;
  final QuestType type;

  QuestModel copyWith({
    String? id,
    String? title,
    String? description,
    int? xpReward,
    bool? isCompleted,
    QuestType? type,
  }) {
    return QuestModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      xpReward: xpReward ?? this.xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'xpReward': xpReward,
      'isCompleted': isCompleted,
      'type': type.name,
    };
  }

  factory QuestModel.fromMap(Map<String, dynamic> map) {
    final String typeValue = map['type'] as String? ?? QuestType.side.name;
    final QuestType parsedType = QuestType.values.firstWhere(
      (QuestType value) => value.name == typeValue,
      orElse: () => QuestType.side,
    );

    return QuestModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      xpReward: (map['xpReward'] as num?)?.toInt() ?? 0,
      isCompleted: map['isCompleted'] as bool? ?? false,
      type: parsedType,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory QuestModel.fromJson(String source) =>
      QuestModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QuestModel(id: $id, title: $title, description: $description, xpReward: $xpReward, isCompleted: $isCompleted, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuestModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.xpReward == xpReward &&
        other.isCompleted == isCompleted &&
        other.type == type;
  }

  @override
  int get hashCode {
    return Object.hash(id, title, description, xpReward, isCompleted, type);
  }
}
