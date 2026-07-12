import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/features/leaves/data/datasources/leaves_local_data_source.dart';
import 'package:leave_manager/features/leaves/data/models/leave_record_mapper.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/features/leaves/domain/repositories/leave_repository.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeavesLocalDataSource localDataSource;

  LeaveRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Unit>> addLeave(LeaveRecord leave) async {
    try {
      // تحديد القيمة الرقمية بناءً على نوع الإجازة
      int typeIndex = 0;
      if (leave.leaveType == LeaveType.regular) {
        typeIndex = 0;
      } else if (leave.leaveType == LeaveType.casual) {
        typeIndex = 1;
      } else {
        typeIndex = 2; // بدل راحة
      }

      final companion = LeaveRecordsTableCompanion(
        leaveType: Value(typeIndex),
        startDate: Value(leave.startDate),
        endDate: Value(leave.endDate),
        daysCount: Value(leave.daysCount),
        notes: Value(leave.notes ?? ''),
      );

      await localDataSource.addLeaveRecord(companion);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<LeaveRecord>>> getLeavesBetweenDates(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final models = await localDataSource.getLeavesBetween(start, end);
      final domainRecords = models.map((model) => model.toDomain()).toList();
      return Right(domainRecords);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLeave(int id) async {
    try {
      await localDataSource.deleteLeaveRecord(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
