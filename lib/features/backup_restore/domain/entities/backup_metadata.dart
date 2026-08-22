// lib/features/backup_restore/domain/entities/backup_metadata.dart
import 'package:equatable/equatable.dart';

/// كيان يمثل البيانات الوصفية للنسخة الاحتياطية
class BackupMetadata extends Equatable {
  final String fileName;
  final DateTime createdAt;
  final double sizeInMB;

  const BackupMetadata({
    required this.fileName,
    required this.createdAt,
    required this.sizeInMB,
  });

  @override
  List<Object?> get props => [fileName, createdAt, sizeInMB];
}