// test/features/notifications/domain/usecases/sync_device_with_server_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/notifications/domain/entities/device_sync_params.dart';
import 'package:leave_manager/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:leave_manager/features/notifications/domain/usecases/sync_device_with_server_usecase.dart';
import 'package:mocktail/mocktail.dart';

/// كلاس محاكاة (Mock) لواجهة مستودع الإشعارات بدون الحاجة لتوليد أكواد.
class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

/// كلاس وهمي (Fake) لتسجيل نوع [DeviceSyncParams] في مكتبة mocktail.
class FakeDeviceSyncParams extends Fake implements DeviceSyncParams {}

void main() {
  late SyncDeviceWithServerUseCase useCase;
  late MockNotificationsRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeDeviceSyncParams());
  });

  setUp(() {
    mockRepository = MockNotificationsRepository();
    useCase = SyncDeviceWithServerUseCase(mockRepository);
  });

  const tValidParams = DeviceSyncParams(
    fcmToken: 'valid_fcm_token_2026',
    osType: 'android',
    appVersion: '1.4.0',
    deviceModel: 'Pixel 9 Pro',
  );

  const tEmptyTokenParams = DeviceSyncParams(
    fcmToken: '   ',
    osType: 'android',
    appVersion: '1.4.0',
  );

  group('SyncDeviceWithServerUseCase Tests (AMD 2026)', () {
    test(
      'يجب أن يرجع ValidationFailure فوراً إذا كان fcmToken فارغاً دون استدعاء المستودع',
      () async {
        // Act
        final result = await useCase(tEmptyTokenParams);

        // Assert
        expect(
          result,
          equals(
            const Left<Failure, Unit>(
              ValidationFailure('رمز الإشعارات (FCM Token) غير صالح.'),
            ),
          ),
        );
        verifyZeroInteractions(mockRepository);
      },
    );

    test(
      'يجب أن يرجع Right(unit) عند نجاح مزامنة بيانات الجهاز مع خادم AppsNotifiersSystem',
      () async {
        // Arrange
        when(() => mockRepository.syncDeviceWithServer(any()))
            .thenAnswer((_) async => const Right(unit));

        // Act
        final result = await useCase(tValidParams);

        // Assert
        expect(result, equals(const Right<Failure, Unit>(unit)));
        verify(() => mockRepository.syncDeviceWithServer(tValidParams))
            .called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'يجب أن يرجع Left(NetworkFailure) عند انقطاع الاتصال بالإنترنت (Offline Mode)',
      () async {
        // Arrange
        when(() => mockRepository.syncDeviceWithServer(any())).thenAnswer(
          (_) async => const Left(NetworkFailure()),
        );

        // Act
        final result = await useCase(tValidParams);

        // Assert
        expect(
          result,
          equals(const Left<Failure, Unit>(NetworkFailure())),
        );
        verify(() => mockRepository.syncDeviceWithServer(tValidParams))
            .called(1);
      },
    );

    test(
      'يجب أن يرجع Left(ServerFailure) إذا رفض الخادم مفتاح التطبيق X-App-Key (401/403)',
      () async {
        // Arrange
        const tServerFailure = ServerFailure(
          'مفتاح التطبيق غير صالح أو غير مصرح له بالوصول.',
          statusCode: 401,
        );
        when(() => mockRepository.syncDeviceWithServer(any())).thenAnswer(
          (_) async => const Left(tServerFailure),
        );

        // Act
        final result = await useCase(tValidParams);

        // Assert
        expect(
          result,
          equals(const Left<Failure, Unit>(tServerFailure)),
        );
        verify(() => mockRepository.syncDeviceWithServer(tValidParams))
            .called(1);
      },
    );
  });
}