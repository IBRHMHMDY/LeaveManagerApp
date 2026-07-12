import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersion extends StatefulWidget {
  const AppVersion({super.key});

  @override
  State<AppVersion> createState() => _AppVersionState();
}

class _AppVersionState extends State<AppVersion> {
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

  @override
  Widget build(BuildContext context) {
    return Text(
      'Version $_version',
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
