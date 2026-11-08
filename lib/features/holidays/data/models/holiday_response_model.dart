import 'package:leave_manager/features/holidays/data/models/holiday_dto.dart';

class HolidayResponseModel {
  final List<HolidayDto> data;

  const HolidayResponseModel({required this.data});

  factory HolidayResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] ?? [];
    
    final List<HolidayDto> holidays = dataList.map((item) {
      return HolidayDto.fromJson(item as Map<String, dynamic>);
    }).toList();

    return HolidayResponseModel(data: holidays);
  }
}