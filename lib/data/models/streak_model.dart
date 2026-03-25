import 'dart:convert';

class StreakModel {
  const StreakModel({required this.currentStreak, this.lastCompletedDate})
    : assert(currentStreak >= 0, 'Current streak cannot be negative');

  final int currentStreak;
  final DateTime? lastCompletedDate;

  StreakModel copyWith({int? currentStreak, DateTime? lastCompletedDate}) {
    return StreakModel(
      currentStreak: currentStreak ?? this.currentStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentStreak': currentStreak,
      // DateTime is accepted by Firestore SDKs and converted to Timestamp.
      'lastCompletedDate': lastCompletedDate,
    };
  }

  factory StreakModel.fromMap(Map<String, dynamic> map) {
    return StreakModel(
      currentStreak: (map['currentStreak'] as num?)?.toInt() ?? 0,
      lastCompletedDate: _parseFirestoreDate(map['lastCompletedDate']),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory StreakModel.fromJson(String source) =>
      StreakModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  static DateTime? _parseFirestoreDate(Object? rawValue) {
    if (rawValue == null) {
      return null;
    }
    if (rawValue is DateTime) {
      return rawValue;
    }
    if (rawValue is String) {
      return DateTime.tryParse(rawValue);
    }
    if (rawValue is int) {
      return DateTime.fromMillisecondsSinceEpoch(rawValue);
    }

    final dynamic dynamicValue = rawValue;
    if (dynamicValue is Object &&
        dynamicValue.toString().contains('Timestamp')) {
      try {
        return (dynamicValue as dynamic).toDate() as DateTime;
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  @override
  String toString() {
    return 'StreakModel(currentStreak: $currentStreak, lastCompletedDate: $lastCompletedDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StreakModel &&
        other.currentStreak == currentStreak &&
        other.lastCompletedDate == lastCompletedDate;
  }

  @override
  int get hashCode => Object.hash(currentStreak, lastCompletedDate);
}
