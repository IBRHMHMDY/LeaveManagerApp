import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [SettingsTable, LeaveRecordsTable, HolidaysTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(holidaysTable);
      }
      if (from < 3) {
        // ترقية قاعدة البيانات لإضافة أعمدة البلد في الإصدار 3
        await m.addColumn(settingsTable, settingsTable.selectedCountry);
        await m.addColumn(holidaysTable, holidaysTable.country);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'leave_manager.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}