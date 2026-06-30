// lib/core/utils/helpers/show_about_developer.dart
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void showAboutDeveloperBottomSheet(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: colorScheme.surface,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (ctx) => const _AboutDeveloperContent(),
  );
}

class _AboutDeveloperContent extends StatefulWidget {
  const _AboutDeveloperContent();

  @override
  State<_AboutDeveloperContent> createState() => _AboutDeveloperContentState();
}

class _AboutDeveloperContentState extends State<_AboutDeveloperContent> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  // دالة لجلب رقم الإصدار من ملف pubspec.yaml تلقائياً
  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = '${info.version} (${info.buildNumber})';
    });
  }

  // دالة لفتح البريد الإلكتروني المطور
  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ibrhmhmdy@example.com', // ضع بريدك الإلكتروني هنا
      queryParameters: {
        'subject': 'تطبيق متتبع الإجازات - تواصل',
      },
    );
    if (!await launchUrl(emailLaunchUri)) {
      debugPrint('لا يمكن فتح البريد الإلكتروني');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. مؤشر السحب (Drag Handle)
          Container(
            width: 45,
            height: 5,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withAlpha(50),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 32),

          // 2. شعار التطبيق (نفس الشعار المستخدم في شاشة البداية)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primary.withAlpha(150)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withAlpha(50),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(Icons.calendar_month_rounded, size: 40, color: colorScheme.onPrimary),
          ),
          const SizedBox(height: 16),

          // 3. اسم التطبيق وإصداره
          Text(
            'مُتتبع الإجازات',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'الإصدار $_version',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(150),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 32),

          // 4. بطاقة معلومات المطور
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withAlpha(100),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outline.withAlpha(50)),
            ),
            child: Column(
              children: [
                Text(
                  'تم التطوير بكل حب لخدمة الموظفين وتنظيم أوقاتهم بطريقة احترافية وذكية.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: colorScheme.onSurface.withAlpha(200),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'تطوير وتصميم',
                  style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withAlpha(150)),
                ),
                Text(
                  'IbrahimHamdy',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 5. زر التواصل
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 54),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.mail_rounded),
            label: const Text('تواصل مع المطور', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: _launchEmail,
          ),
          const SizedBox(height: 16),
          
          // 6. حقوق الملكية
          Text(
            '© ${DateTime.now().year} جميع الحقوق محفوظة',
            style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withAlpha(100)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}