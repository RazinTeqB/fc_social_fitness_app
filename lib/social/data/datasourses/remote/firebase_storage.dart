import 'dart:io';

import 'package:fc_social_fitness/models/api_response.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import '../../../../repositories/upload.repository.dart';
import 'dart:math';

class FirebaseStoragePost {
  static Future<String> uploadFile({
    required String folderName,
    required File postFile,
  }) async {
    UploadRepository uploadRepository = UploadRepository();
   /* final fileName = basename(postFile.path);
    final destination = 'files/$folderName/$fileName';
    final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
    UploadTask uploadTask = ref.putFile(postFile);
    String fileOfPostUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
            return fileOfPostUrl;
*/
    ApiResponse response = await uploadRepository.uploadFile(folderName,postFile);
    return response.body["file_url"];
  }

}
