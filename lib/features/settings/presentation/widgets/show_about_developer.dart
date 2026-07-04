import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:leave_manager/features/app/presentation/widgets/custom_app_logo_icon.dart';

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

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = '${info.version} (${info.buildNumber})';
    });
  }

  // دالة فتح البريد الإلكتروني
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

  // دالة فتح الواتساب (WhatsApp) المضافة حديثاً
  Future<void> _launchWhatsApp() async {
    // ضع رقم هاتفك هنا مع مفتاح الدولة بدون أصفار أو علامة + (مثال لمصر: 201000000000)
    const String phoneNumber = '2001007576297'; 
    // الرسالة الافتراضية التي ستظهر في المحادثة
    final String message = Uri.encodeComponent('مرحباً، لدي استفسار بخصوص تطبيق دفتر أجازاتى.');
    
    // استخدام الرابط العالمي wa.me لضمان التوافقية
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber?text=$message');

    // LaunchMode.externalApplication يضمن الخروج من التطبيق وفتح الواتساب بشكل نظيف
    if (!await launchUrl(whatsappUri, mode: LaunchMode.externalApplication)) {
      debugPrint('لا يمكن فتح الواتساب');
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

          // 2. شعار التطبيق
          CustomAppLogoIcon(context),
          const SizedBox(height: 16),

          // 3. اسم التطبيق وإصداره
          Text(
            'دفتر اجازاتى',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
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

          // 5. زر التواصل عبر واتساب (الجديد)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: const Color(0xFF25D366), // لون الواتساب الرسمي
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.chat_bubble_outline_rounded), // أيقونة المحادثة
            label: const Text('تواصل عبر واتساب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: _launchWhatsApp,
          ),
          const SizedBox(height: 12),

          // 6. زر التواصل عبر البريد الإلكتروني (تصميم مختلف لتمييزه)
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              foregroundColor: colorScheme.primary,
              side: BorderSide(color: colorScheme.primary.withAlpha(100), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.mail_outline_rounded),
            label: const Text('إرسال بريد إلكتروني', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: _launchEmail,
          ),
          
          const SizedBox(height: 24),
          
          // 7. حقوق الملكية
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