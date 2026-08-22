import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';

abstract class NotificationsLocalDataSource {
  Future<void> saveNotification(NotificationsTableCompanion companion);
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(int id);
  Future<int> getUnreadCount();
  Future<void> deleteNotification(int id);
}

@LazySingleton(as: NotificationsLocalDataSource)
class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  final AppDatabase db;

  NotificationsLocalDataSourceImpl(this.db);

  @override
  Future<void> saveNotification(NotificationsTableCompanion companion) async {
    try {
      await db.into(db.notificationsTable).insert(companion);
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء حفظ الإشعار.');
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      return await (db.select(db.notificationsTable)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء جلب الإشعارات.');
    }
  }

  @override
  Future<void> markAsRead(int id) async {
    try {
      await (db.update(db.notificationsTable)
            ..where((tbl) => tbl.id.equals(id)))
          .write(const NotificationsTableCompanion(
        isRead: Value(true),
      ));
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء تحديث حالة الإشعار.');
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final unreadQuery = db.select(db.notificationsTable)
        ..where((tbl) => tbl.isRead.equals(false));
      final unreadList = await unreadQuery.get();
      return unreadList.length;
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء جلب عدد الإشعارات.');
    }
  }

  @override
  Future<void> deleteNotification(int id) async {
    try {
      await (db.delete(db.notificationsTable)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء حذف الإشعار.');
    }
  }
}