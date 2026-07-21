import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:leave_manager/core/database/tables/holidays_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/settings_table.dart';
import 'tables/leave_records_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [SettingsTable, LeaveRecordsTable, HolidaysTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // إنشاء جميع الجداول للمستخدمين الجدد
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          await m.createTable(holidaysTable);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db_leave_manager.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
