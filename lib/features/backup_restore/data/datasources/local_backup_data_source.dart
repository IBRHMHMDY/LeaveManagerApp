import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

abstract class LocalBackupDataSource {
  Future<String> backupToLocal();
  Future<void> restoreFromLocal();
  Future<File> getDatabaseFile();
}

@LazySingleton(as: LocalBackupDataSource)
class LocalBackupDataSourceImpl implements LocalBackupDataSource {
  static const String _dbName = 'db_leave_manager.sqlite';

  @override
  Future<File> getDatabaseFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    return File(p.join(dbFolder.path, _dbName));
  }

  @override
  Future<String> backupToLocal() async {
    final dbFile = await getDatabaseFile();
    if (!await dbFile.exists()) {
      throw DatabaseException('قاعدة البيانات غير موجودة.');
    }

    try {
      final appDir = await getApplicationDocumentsDirectory();
      // إنشاء مجلد داخلي مخفي للنسخ الاحتياطية
      final backupDir = Directory(p.join(appDir.path, 'backups'));
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      final backupFile = File(p.join(backupDir.path, 'backup_${DateTime.now().millisecondsSinceEpoch}.sqlite'));
      await dbFile.copy(backupFile.path);

      // نرجع رسالة نجاح بدلاً من المسار لمنع المستخدم من معرفته
      return 'تم حفظ النسخة المحلية بأمان.';
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء حفظ الملف الاحتياطي.');
    }
  }

  @override
  Future<void> restoreFromLocal() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory(p.join(appDir.path, 'backups'));

      if (!await backupDir.exists()) {
        throw ValidationException('لا توجد أي نسخ احتياطية محفوظة محلياً.');
      }

      // جلب جميع الملفات التي تنتهي بـ .sqlite
      final List<FileSystemEntity> files = backupDir.listSync();
      final backupFiles = files
          .whereType<File>()
          .where((f) => f.path.endsWith('.sqlite'))
          .toList();

      if (backupFiles.isEmpty) {
        throw ValidationException('لا توجد أي نسخ احتياطية محفوظة محلياً.');
      }

      // ترتيب الملفات تنازلياً حسب تاريخ التعديل لجلب الأحدث (Latest)
      backupFiles.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      final latestBackup = backupFiles.first;

      final currentDbFile = await getDatabaseFile();
      // نسخ أحدث ملف فوق قاعدة البيانات الأصلية
      await latestBackup.copy(currentDbFile.path);
    } catch (e) {
      if (e is ValidationException) rethrow; // لتمرير رسالة عدم وجود نسخ
      throw DatabaseException('حدث خطأ أثناء استعادة النسخة المحلية.');
    }
  }
}