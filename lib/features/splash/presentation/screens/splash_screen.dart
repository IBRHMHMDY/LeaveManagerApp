// lib/features/splash/presentation/screens/splash_screen.dart

import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/network/network_info.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/services/push_notification_service.dart';
import 'package:leave_manager/core/utils/extensions/theme_extension.dart';
import 'package:leave_manager/features/app_updates/presentation/cubit/app_update_cubit.dart';
import 'package:leave_manager/features/app_updates/presentation/cubit/app_update_state.dart';
import 'package:leave_manager/features/app_updates/presentation/widgets/update_alert_dialog.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_event.dart';
import 'package:leave_manager/features/notifications/domain/entities/device_sync_params.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_event.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_state.dart';
import 'package:leave_manager/features/settings/presentation/widgets/app_version.dart';
import 'package:leave_manager/features/splash/presentation/widgets/custom_app_logo.dart';
import 'package:leave_manager/shared/widgets/overlays/app_toast.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<Offset> _textSlideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(milliseconds: 3000));
      if (mounted) {
        // الخطوة 1: فحص التحديثات أولاً (سيتم إكمال الدورة عبر الـ Listener)
        context.read<AppUpdateCubit>().checkForUpdates();
      }
    } catch (e, stackTrace) {
      debugPrint('Splash Init Error: $e\n$stackTrace');
      if (mounted) {
        AppToast.showError(context, 'حدث خطأ أثناء تهيئة التطبيق.');
        context.go(AppRouter.setup);
      }
    }
  }

  Future<String?> _triggerBackgroundPushSync() async {
    try {
      final isConnected = await sl<NetworkInfo>().isConnected;
      if (!isConnected) {
        if (mounted) {
          AppToast.showWarning(
            context,
            'لا يوجد اتصال بالإنترنت، لم يتم مزامنة الإشعارات.',
          );
        }
        return null;
      }

      final pushService = sl<PushNotificationService>();
      await pushService.initialize();

      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        final osType = Platform.isAndroid ? 'android' : 'ios';
        final appVersion = (await PackageInfo.fromPlatform()).version;

        if (mounted) {
          context.read<NotificationsBloc>().add(
            SyncDeviceTokenEvent(
              DeviceSyncParams(
                fcmToken: fcmToken,
                osType: osType,
                appVersion: appVersion,
                forceSync: true,
              ),
            ),
          );
        }
      }

      // جلب وتفريغ المسار المحفوظ
      final route = pushService.initialActionUrl;
      pushService.initialActionUrl = null;
      return route;
    } catch (e) {
      debugPrint('Background sync bypassed: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppUpdateCubit, AppUpdateState>(
          listener: (context, state) {
            if (state is AppUpdateAvailable) {
              if (state.updateInfo.forceUpdate) {
                context.go(
                  AppRouter.forceUpdate,
                  extra: state.updateInfo.message,
                );
              } else {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => UpdateAlertDialog(
                    message: state.updateInfo.message,
                    onSkip: () {
                      context.read<SettingsBloc>().add(CheckSettingsEvent());
                    },
                  ),
                );
              }
            } else if (state is AppUpdateError) {
              AppToast.showWarning(context, state.message);
              context.read<SettingsBloc>().add(CheckSettingsEvent());
            } else if (state is AppVersionLoaded) {
              if (context.read<SettingsBloc>().state is SettingsInitial) {
                context.read<SettingsBloc>().add(CheckSettingsEvent());
              }
            }
          },
        ),

        // تعديل مستمع الإعدادات للتعامل مع الـ Deep Link
        BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) async {
            if (state is SettingsExists) {
              context.read<SettingsBloc>().add(LoadSettingsEvent());
              context.read<LeavesBloc>().add(LoadBalancesAndLeavesEvent());
              context.read<RestAllowancesBloc>().add(LoadRestAllowancesEvent());
              context.read<HolidaysCubit>().loadHolidays();
              context.read<NotificationsBloc>().add(
                const LoadNotificationsEvent(),
              );

              // انتظار التهيئة وقراءة الرابط القادم من الإشعار
              final pendingRoute = await _triggerBackgroundPushSync();

              if (!context.mounted) return;

              SystemChrome.setEnabledSystemUIMode(
                SystemUiMode.manual,
                overlays: SystemUiOverlay.values,
              );

              // التوجيه بناءً على الرابط بدلاً من الرئيسية بشكل أعمى
              if (pendingRoute != null && pendingRoute.startsWith('/')) {
                context.go(pendingRoute);
              } else {
                context.go(AppRouter.home);
              }
            } else if (state is SettingsNotFound) {
              context.read<NotificationsBloc>().add(
                const LoadNotificationsEvent(),
              );

              final _ = await _triggerBackgroundPushSync();

              if (!context.mounted) return;

              SystemChrome.setEnabledSystemUIMode(
                SystemUiMode.manual,
                overlays: SystemUiOverlay.values,
              );
              context.go(AppRouter.setup);
            } else if (state is SettingsError) {
              AppToast.showError(context, state.message);
              context.go(AppRouter.setup);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: Stack(
          children: [
            Positioned(
              top: -100,
              right: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colorScheme.primary.withAlpha(15),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colorScheme.secondary.withAlpha(15),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: const CustomAppLogo(),
                  ),
                  const SizedBox(height: 32),
                  SlideTransition(
                    position: _textSlideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text(
                            'مدير إجازاتي',
                            style: context.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: context.colorScheme.primary,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: context.colorScheme.primaryContainer
                                  .withAlpha(150),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'تتبع إجازاتك بذكاء وسهولة',
                              style: context.textTheme.titleSmall?.copyWith(
                                color: context.colorScheme.onSurface,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.5,
                        color: context.colorScheme.primary.withAlpha(150),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const AppVersion(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
