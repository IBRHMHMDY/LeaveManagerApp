import 'package:drift/drift.dart';

/// جدول الإشعارات المستقل في قاعدة البيانات
@DataClassName('NotificationModel')
class NotificationsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get payload => text().nullable()(); // الـ Payload قد يكون فارغاً
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}