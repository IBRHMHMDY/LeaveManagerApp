import 'package:leave_manager/core/database/app_database.dart';

class HolidayResponseModel {
  final List<HolidayModel> data;

  const HolidayResponseModel({required this.data});

  factory HolidayResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] ?? [];
    
    final List<HolidayModel> holidays = dataList.map((item) {
      return HolidayModel(
        id: item['id'] as int,
        name: item['name'] as String,
        startDate: DateTime.parse(item['start_date'] as String),
        endDate: DateTime.parse(item['end_date'] as String),
        daysCount: item['days_count'] as int? ?? 1, // قراءة days_count من الباكند
      );
    }).toList();

    return HolidayResponseModel(data: holidays);
  }
}