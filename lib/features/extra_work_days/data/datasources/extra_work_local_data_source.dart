import 'package:drift/drift.dart';
import 'package:leave_manager/core/database/app_database.dart';


abstract class ExtraWorkLocalDataSource {
  Future<List<ExtraWorkDayModel>> getExtraWorkDays();
  Future<int> addExtraWorkDay(ExtraWorkDaysTableCompanion extraWorkDay);
  Future<int> deleteExtraWorkDay(int id);
}

class ExtraWorkLocalDataSourceImpl implements ExtraWorkLocalDataSource {
  final AppDatabase database;

  ExtraWorkLocalDataSourceImpl({required this.database});

  @override
  Future<List<ExtraWorkDayModel>> getExtraWorkDays() async {
    // جلب الأيام الإضافية مرتبة من الأحدث للأقدم
    return await (database.select(database.extraWorkDaysTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .get();
  }

  @override
  Future<int> addExtraWorkDay(ExtraWorkDaysTableCompanion extraWorkDay) async {
    return await database.into(database.extraWorkDaysTable).insert(extraWorkDay);
  }

  @override
  Future<int> deleteExtraWorkDay(int id) async {
    return await (database.delete(database.extraWorkDaysTable)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}