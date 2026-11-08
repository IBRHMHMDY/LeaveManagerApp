class HolidayDto {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int daysCount;

  const HolidayDto({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.daysCount,

  });

  factory HolidayDto.fromJson(Map<String, dynamic> json) {
    return HolidayDto(
      id: json['id'] as int,
      name: json['name'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      daysCount: json['days_count'] as int? ?? 1,
    );
  }
}