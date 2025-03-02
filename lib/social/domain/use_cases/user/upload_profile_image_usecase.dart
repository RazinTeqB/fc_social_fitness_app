import 'dart:io';
import 'dart:typed_data';
import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import '../../repositories/user_repository.dart';

class UploadProfileImageUseCase
    implements UseCaseThreeParams<String, File, String, String> {
  final FirestoreUserRepository _addNewUserRepository;

  UploadProfileImageUseCase(this._addNewUserRepository);

  @override
  Future<String> call(
      {required File paramsOne,
      required String paramsTwo,
      required String paramsThree}) {
    return _addNewUserRepository.uploadProfileImage(
        photo: paramsOne, userId: paramsTwo, previousImageUrl: paramsThree);
  }
}
