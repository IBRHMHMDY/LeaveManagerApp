// lib/features/backup_restore/domain/usecases/auth_google_usecases.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/backup_restore/domain/repositories/backup_repository.dart';

@lazySingleton
class SignInWithGoogleUseCase implements BaseUseCase<Unit, NoParams> {
  final BackupRepository repository;
  SignInWithGoogleUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.signInWithGoogle();
  }
}

@lazySingleton
class SignOutFromGoogleUseCase implements BaseUseCase<Unit, NoParams> {
  final BackupRepository repository;
  SignOutFromGoogleUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.signOutFromGoogle();
  }
}

@lazySingleton
class IsGoogleSignedInUseCase implements BaseUseCase<bool, NoParams> {
  final BackupRepository repository;
  IsGoogleSignedInUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isGoogleSignedIn();
  }
}