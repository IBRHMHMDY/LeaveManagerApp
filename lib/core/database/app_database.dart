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

  // تم رفع الإصدار إلى 4 (لأن الإصدار في المتجر حالياً هو 3)
  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      // للمستخدمين الجدد الذين يثبتون التطبيق لأول مرة
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // للمستخدمين الحاليين الذين يقومون بالتحديث من المتجر
      
      // إذا كان المستخدم قادماً من إصدار قديم جداً (أقل من 2)
      if (from < 2) {
        await m.createTable(holidaysTable);
      }
      
      // إذا كان المستخدم قادماً من إصدار (أقل من 3) 
      // نتجاهل إضافة أعمدة البلد لأننا سنحذفها في الإصدار 4
      
      // التحديث الجديد (الإصدار 4): إزالة حقول البلد بأمان مع الحفاظ على البيانات
      if (from < 4) {
        // TableMigration تقوم بنسخ البيانات القديمة وإعادة إنشاء الجدول 
        // بدون الأعمدة التي قمنا بحذفها، مما يحمي بيانات المستخدم من الضياع
        await m.alterTable(TableMigration(settingsTable));
        await m.alterTable(TableMigration(holidaysTable));
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
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