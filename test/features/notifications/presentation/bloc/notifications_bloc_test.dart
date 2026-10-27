// test/features/notifications/presentation/bloc/notifications_bloc_test.dart
import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/services/push_notification_service.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:leave_manager/features/notifications/domain/usecases/clear_all_notifications_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/get_local_notifications_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/get_unread_notifications_count_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/mark_all_notifications_as_read_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/save_notification_usecase.dart';
import 'package:leave_manager/features/notifications/domain/usecases/sync_device_with_server_usecase.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_state.dart';
import 'package:mocktail/mocktail.dart';

class MockSyncDeviceWithServerUseCase extends Mock
    implements SyncDeviceWithServerUseCase {}

class MockSaveNotificationUseCase extends Mock
    implements SaveNotificationUseCase {}

class MockGetLocalNotificationsUseCase extends Mock
    implements GetLocalNotificationsUseCase {}

class MockGetUnreadNotificationsCountUseCase extends Mock
    implements GetUnreadNotificationsCountUseCase {}

class MockMarkNotificationAsReadUseCase extends Mock
    implements MarkNotificationAsReadUseCase {}

class MockMarkAllNotificationsAsReadUseCase extends Mock
    implements MarkAllNotificationsAsReadUseCase {}

class MockDeleteNotificationUseCase extends Mock
    implements DeleteNotificationUseCase {}

class MockClearAllNotificationsUseCase extends Mock
    implements ClearAllNotificationsUseCase {}

class MockPushNotificationService extends Mock
    implements PushNotificationService {}

class FakeAppNotificationEntity extends Fake implements AppNotificationEntity {}

void main() {
  late NotificationsBloc notificationsBloc;
  late MockSyncDeviceWithServerUseCase mockSyncDevice;
  late MockSaveNotificationUseCase mockSaveNotification;
  late MockGetLocalNotificationsUseCase mockGetLocalNotifications;
  late MockGetUnreadNotificationsCountUseCase mockGetUnreadCount;
  late MockMarkNotificationAsReadUseCase mockMarkAsRead;
  late MockMarkAllNotificationsAsReadUseCase mockMarkAllAsRead;
  late MockDeleteNotificationUseCase mockDeleteNotification;
  late MockClearAllNotificationsUseCase mockClearAllNotifications;
  late MockPushNotificationService mockPushNotificationService;
  late StreamController<AppNotificationEntity> foregroundStreamController;

  final tReceivedDate = DateTime(2026, 10, 17, 10, 30);

  final tNotification = AppNotificationEntity(
    id: 1,
    remoteId: 'fcm_msg_001',
    title: 'تحديث العطلات الرسمية',
    body: 'تمت إضافة إجازة رسمية جديدة، تفقد جدول العطلات.',
    actionUrl: '/holidays',
    isRead: false,
    receivedAt: tReceivedDate,
  );

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(FakeAppNotificationEntity());
  });

  setUp(() {
    mockSyncDevice = MockSyncDeviceWithServerUseCase();
    mockSaveNotification = MockSaveNotificationUseCase();
    mockGetLocalNotifications = MockGetLocalNotificationsUseCase();
    mockGetUnreadCount = MockGetUnreadNotificationsCountUseCase();
    mockMarkAsRead = MockMarkNotificationAsReadUseCase();
    mockMarkAllAsRead = MockMarkAllNotificationsAsReadUseCase();
    mockDeleteNotification = MockDeleteNotificationUseCase();
    mockClearAllNotifications = MockClearAllNotificationsUseCase();
    mockPushNotificationService = MockPushNotificationService();

    foregroundStreamController =
        StreamController<AppNotificationEntity>.broadcast();

    when(() => mockPushNotificationService.onForegroundNotificationStream)
        .thenAnswer((_) => foregroundStreamController.stream);

    notificationsBloc = NotificationsBloc(
      syncDeviceWithServer: mockSyncDevice,
      saveNotification: mockSaveNotification,
      getLocalNotifications: mockGetLocalNotifications,
      getUnreadCount: mockGetUnreadCount,
      markAsRead: mockMarkAsRead,
      markAllAsRead: mockMarkAllAsRead,
      deleteNotification: mockDeleteNotification,
      clearAllNotifications: mockClearAllNotifications,
      pushNotificationService: mockPushNotificationService,
    );
  });

  tearDown(() async {
    await notificationsBloc.close();
    await foregroundStreamController.close();
  });

  group('NotificationsBloc Unit Tests (AMD 2026)', () {
    test('الحالة الابتدائية يجب أن تكون NotificationsInitial', () {
      expect(notificationsBloc.state, equals(const NotificationsInitial()));
    });

    blocTest<NotificationsBloc, NotificationsState>(
      'يطلق [NotificationsLoading, NotificationsLoaded] عند نجاح LoadNotificationsEvent',
      build: () {
        when(() => mockGetLocalNotifications(any()))
            .thenAnswer((_) async => Right([tNotification]));
        when(() => mockGetUnreadCount(any()))
            .thenAnswer((_) async => const Right(1));
        return notificationsBloc;
      },
      act: (bloc) => bloc.add(const LoadNotificationsEvent()),
      expect: () => [
        const NotificationsLoading(),
        NotificationsLoaded(
          notifications: [tNotification],
          unreadCount: 1,
        ),
      ],
      verify: (_) {
        verify(() => mockGetLocalNotifications(const NoParams())).called(1);
        verify(() => mockGetUnreadCount(const NoParams())).called(1);
      },
    );

    blocTest<NotificationsBloc, NotificationsState>(
      'يطلق [NotificationsLoading, NotificationsError] عند فشل قاعدة البيانات المحلية',
      build: () {
        when(() => mockGetLocalNotifications(any())).thenAnswer(
          (_) async => const Left(DatabaseFailure('تعذر تحميل سجل الإشعارات.')),
        );
        when(() => mockGetUnreadCount(any()))
            .thenAnswer((_) async => const Right(0));
        return notificationsBloc;
      },
      act: (bloc) => bloc.add(const LoadNotificationsEvent()),
      expect: () => [
        const NotificationsLoading(),
        const NotificationsError('تعذر تحميل سجل الإشعارات.'),
      ],
    );

    blocTest<NotificationsBloc, NotificationsState>(
      'يستقبل الإشعار الفوري من PushNotificationService ويحفظه ثم يطلق IncomingNotificationAlertState ويحدّث القائمة',
      build: () {
        when(() => mockSaveNotification(any()))
            .thenAnswer((_) async => const Right(unit));
        when(() => mockGetLocalNotifications(any()))
            .thenAnswer((_) async => Right([tNotification]));
        when(() => mockGetUnreadCount(any()))
            .thenAnswer((_) async => const Right(1));
        return notificationsBloc;
      },
      act: (_) async {
        foregroundStreamController.add(tNotification);
      },
      expect: () => [
        IncomingNotificationAlertState(tNotification),
        const NotificationsLoading(),
        NotificationsLoaded(
          notifications: [tNotification],
          unreadCount: 1,
        ),
      ],
      verify: (_) {
        verify(() => mockSaveNotification(tNotification)).called(1);
      },
    );

    blocTest<NotificationsBloc, NotificationsState>(
      'يحدّث جميع الإشعارات كمقروءة ويطلق NotificationsActionSuccess ثم يعيد تحميل القائمة بعدد غير مقروء = 0',
      build: () {
        final readNotification = tNotification.copyWith(isRead: true);
        when(() => mockMarkAllAsRead(any()))
            .thenAnswer((_) async => const Right(unit));
        when(() => mockGetLocalNotifications(any()))
            .thenAnswer((_) async => Right([readNotification]));
        when(() => mockGetUnreadCount(any()))
            .thenAnswer((_) async => const Right(0));
        return notificationsBloc;
      },
      act: (bloc) => bloc.add(const MarkAllNotificationsReadEvent()),
      expect: () => [
        const NotificationsActionSuccess('تم تحديد جميع الإشعارات كمقروءة.'),
        const NotificationsLoading(),
        NotificationsLoaded(
          notifications: [tNotification.copyWith(isRead: true)],
          unreadCount: 0,
        ),
      ],
    );
  });
}