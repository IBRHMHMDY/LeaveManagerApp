import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:leave_manager/features/backup_restore/domain/entities/backup_metadata.dart';

abstract class RemoteBackupDataSource {
  Future<void> signInWithGoogle();
  Future<void> signOutFromGoogle();
  Future<bool> isGoogleSignedIn();
  Future<void> backupToCloud(File dbFile);
  Future<void> restoreFromCloud(File destinationFile);
  Future<BackupMetadata?> getLastCloudBackupMetadata();
}

// أداة مساعدة لربط GoogleSignIn مع HTTP Client الخاص بـ GoogleApis
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

@LazySingleton(as: RemoteBackupDataSource)
class RemoteBackupDataSourceImpl implements RemoteBackupDataSource {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveAppdataScope], // صلاحية الوصول للمجلد المخفي للتطبيق فقط
  );

  Future<drive.DriveApi> _getDriveApi() async {
    final account = _googleSignIn.currentUser ?? await _googleSignIn.signIn();
    if (account == null) throw Exception('فشل تسجيل الدخول بحساب Google');
    
    final headers = await account.authHeaders;
    final client = GoogleAuthClient(headers);
    return drive.DriveApi(client);
  }

  @override
  Future<void> signInWithGoogle() async => await _googleSignIn.signIn();

  @override
  Future<void> signOutFromGoogle() async => await _googleSignIn.signOut();

  @override
  Future<bool> isGoogleSignedIn() async => await _googleSignIn.isSignedIn();

  @override
  Future<void> backupToCloud(File dbFile) async {
    final driveApi = await _getDriveApi();
    
    // البحث عن نسخة قديمة لحذفها أو تحديثها
    final fileList = await driveApi.files.list(spaces: 'appDataFolder');
    if (fileList.files != null && fileList.files!.isNotEmpty) {
      for (var file in fileList.files!) {
        await driveApi.files.delete(file.id!);
      }
    }

    // رفع النسخة الجديدة
    final driveFile = drive.File()
      ..name = 'leave_manager_backup.sqlite'
      ..parents = ['appDataFolder'];
      
    await driveApi.files.create(
      driveFile,
      uploadMedia: drive.Media(dbFile.openRead(), dbFile.lengthSync()),
    );
  }

  @override
  Future<void> restoreFromCloud(File destinationFile) async {
    final driveApi = await _getDriveApi();
    final fileList = await driveApi.files.list(spaces: 'appDataFolder');
    
    if (fileList.files == null || fileList.files!.isEmpty) {
      throw Exception('لا توجد نسخة احتياطية سحابية.');
    }

    final backupFileId = fileList.files!.first.id!;
    final drive.Media media = await driveApi.files.get(
      backupFileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final List<int> dataStore = [];
    await for (final data in media.stream) {
      dataStore.addAll(data);
    }
    await destinationFile.writeAsBytes(dataStore);
  }

  @override
  Future<BackupMetadata?> getLastCloudBackupMetadata() async {
    final driveApi = await _getDriveApi();
    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      $fields: 'files(name, createdTime, size)',
    );
    
    if (fileList.files == null || fileList.files!.isEmpty) return null;
    
    final file = fileList.files!.first;
    return BackupMetadata(
      fileName: file.name ?? 'Unknown',
      createdAt: file.createdTime ?? DateTime.now(),
      sizeInMB: (int.parse(file.size ?? '0') / (1024 * 1024)),
    );
  }
}