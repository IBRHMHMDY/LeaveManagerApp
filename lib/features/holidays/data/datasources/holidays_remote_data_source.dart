import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/constants/api_constants.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/core/network/dio_client.dart';
import 'package:leave_manager/features/holidays/data/models/holiday_response_model.dart';

abstract class HolidaysRemoteDataSource {
  Future<HolidayResponseModel> getHolidays();
}

@LazySingleton(as: HolidaysRemoteDataSource)
class HolidaysRemoteDataSourceImpl implements HolidaysRemoteDataSource {
  final DioClient _dioClient;

  const HolidaysRemoteDataSourceImpl(this._dioClient);

  @override
  Future<HolidayResponseModel> getHolidays() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.holidays);

      final statusCode = response.statusCode ?? 500;
      if (statusCode >= 200 && statusCode < 300 && response.data != null) {
        return HolidayResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch holidays', statusCode: statusCode);
      }
    } on DioException catch (dioError, stackTrace) {
      debugPrint('Dio Fetch Holidays Error: $dioError\n$stackTrace');
      throw ServerException.fromDioException(dioError);
    } catch (e, stackTrace) {
      debugPrint('Unexpected Fetch Holidays Error: $e\n$stackTrace');
      throw const ServerException('حدث خطأ غير متوقع أثناء جلب العطلات.');
    }
  }
}