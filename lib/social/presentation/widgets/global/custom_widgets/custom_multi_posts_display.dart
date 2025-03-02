import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/time_line_w/image_slider.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/time_line_w/points_scroll_bar.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_memory_image_display.dart';

class CustomMultiImagesDisplay extends StatelessWidget {
  final initPosition = ValueNotifier(0);
  final List<File> selectedImages;
  CustomMultiImagesDisplay({Key? key, required this.selectedImages})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(top: 8.0),
            child: selectedImages.length > 1
                ? ImagesSlider(
                    aspectRatio: 1,
                    imagesUrls: selectedImages,
                    isImageFromNetwork: false,
                    updateImageIndex: _updateImageIndex,
                  )
                : Hero(
                    tag: selectedImages[0],
                    child: MemoryDisplay(
                        imagePath: selectedImages[0].readAsBytesSync()),
                  ),
          ),
        ),
        if (selectedImages.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: initPosition,
                  builder: (BuildContext context, int value, Widget? child) =>
                      PointsScrollBar(
                    photoCount: selectedImages.length,
                    activePhotoIndex: value,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _updateImageIndex(int index, _) {
    initPosition.value = index;
  }
}
