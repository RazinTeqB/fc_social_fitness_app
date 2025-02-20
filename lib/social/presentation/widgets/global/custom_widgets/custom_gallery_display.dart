import 'dart:io';
import 'package:fc_social_fitness/utils/italian_camera_picker_text_delegate.dart';
import 'package:flutter/material.dart';

import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../../../../../my_app.dart';
import '../../../../../utils/image_editor_plus/image_editor_plus.dart';
import '../../../../../utils/italian_assets_picker_text_delegate.dart';

class CustomImagePickerPlus {
  static Future<File?> pickBoth(BuildContext context) async {
    File? outputFile;
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        themeColor: Colors.red,
        textDelegate: MyApp.of(context)
            .getLocale()
            ?.countryCode == "en"
            ? EnglishAssetPickerTextDelegate() : ItalianAssetPickerTextDelegate(),
        maxAssets: 1,
        specialItemPosition: SpecialItemPosition.prepend,
        specialItemBuilder: (
          BuildContext context,
          AssetPathEntity? path,
          int length,
        ) {
          if (path?.isAll != true) {
            return null;
          }
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              Feedback.forTap(context);
              final AssetEntity? resultCameraPicker =
                  await pickFromCamera(context);
              if (resultCameraPicker != null) {
                File? fileFromPicker = await resultCameraPicker.file;
                List<String>? splitPath = fileFromPicker?.path.split("/");
                if (splitPath == null) {
                  splitPath = [];
                  splitPath.add("FcSocialFitnessPost.jpg");
                }
                String fileName = splitPath.last;
                if (fileFromPicker != null) {
                  String? mimeType = lookupMimeType(fileFromPicker.path);
                  if (!mimeType!.startsWith('video/')) {
                    var imagefile = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageEditor(
                          savePath: Directory("FcSocialFitness"),
                          image: File(fileFromPicker.path).readAsBytesSync(),
                        ),
                      ),
                    );
                    final tempDir = await getTemporaryDirectory();
                    outputFile =
                        await File('${tempDir.path}/$fileName').create();
                    outputFile?.writeAsBytesSync(imagefile);
                  } else {
                    outputFile = await File(fileFromPicker.path);
                  }
                }
                /*if(outputFile!=null)
                  {
                    await moveToCreationPage(context, outputFile!);
                  }*/
                return;
              }
            },
            child: const Center(
              child: Icon(Icons.camera_enhance, size: 42.0),
            ),
          );
        },
      ),
    );
    File? fileFromPicker = await result?[0].file;
    List<String>? splitPath = fileFromPicker?.path.split("/");
    if (splitPath == null) {
      splitPath = [];
      splitPath.add("FcSocialFitnessPost.jpg");
    }
    String fileName = splitPath.last;
    if (fileFromPicker != null) {
      String? mimeType = lookupMimeType(fileFromPicker.path);
      if (!mimeType!.startsWith('video/')) {
        var imagefile = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageEditor(
              savePath: Directory("FcSocialFitness"),
              image: File(fileFromPicker.path).readAsBytesSync(),
            ),
          ),
        );
        final tempDir = await getTemporaryDirectory();
        outputFile = await File('${tempDir.path}/$fileName').create();
        outputFile?.writeAsBytesSync(imagefile);
      } else {
        outputFile = await File(fileFromPicker.path);
      }
    }
    return outputFile;
  }

  static Future<AssetEntity?> pickFromCamera(BuildContext context) {
    return CameraPicker.pickFromCamera(
      context,
      pickerConfig: CameraPickerConfig(
          enableRecording: true,
          textDelegate: MyApp.of(context).getLocale()?.countryCode == "en"
              ? EnglishCameraPickerTextDelegate()
              : ItalianCameraPickerTextDelegate()),
    );
  }

  static SliverGridDelegateWithFixedCrossAxisCount _sliverGridDelegate(
      bool isThatStory) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: isThatStory ? 3 : 4,
      crossAxisSpacing: 1.7,
      mainAxisSpacing: 1.5,
      childAspectRatio: isThatStory ? .5 : 1,
    );
  }
}
