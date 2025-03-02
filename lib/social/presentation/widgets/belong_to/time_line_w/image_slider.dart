import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/time_line_w/points_scroll_bar.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_memory_image_display.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/popup_widgets/common/jump_arrow.dart';
import 'package:mime/mime.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';

class ImagesSlider extends StatefulWidget {
  final List<dynamic> imagesUrls;
  final double aspectRatio;
  final bool showPointsScrollBar;
  final Function(int, CarouselPageChangedReason) updateImageIndex;
  final bool isImageFromNetwork;
  const ImagesSlider({
    Key? key,
    required this.imagesUrls,
    required this.updateImageIndex,
    required this.aspectRatio,
    this.isImageFromNetwork = true,
    this.showPointsScrollBar = false,
  }) : super(key: key);

  @override
  State<ImagesSlider> createState() => _ImagesSliderState();
}

class _ImagesSliderState extends State<ImagesSlider> {
  ValueNotifier<int> initPosition = ValueNotifier(0);
  ValueNotifier<double> countOpacity = ValueNotifier(0);
  final CarouselController _controller = CarouselController();
  late List<File> selectedImages;
  @override
  void didChangeDependencies() {
    if (widget.imagesUrls.isNotEmpty && widget.isImageFromNetwork) {
      widget.imagesUrls.map((url) => precacheImage(NetworkImage(url), context));
    } else {
      selectedImages = widget.imagesUrls as List<File>;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double withOfScreen = MediaQuery.of(context).size.width;
    bool minimumWidth = withOfScreen > 800;
    return Center(
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: ValueListenableBuilder(
          valueListenable: initPosition,
          builder:
              (BuildContext context, int initPositionValue, Widget? child) =>
                  Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider.builder(
                itemCount: widget.imagesUrls.length,
                carouselController: _controller,
                itemBuilder: (context, index, realIndex) {
                  if (widget.isImageFromNetwork) {
                    dynamic imageUrl = widget.imagesUrls[index];
                    bool isThatVideo = imageUrl.toString().contains("mp4");
                    return NetworkDisplay(
                      aspectRatio: widget.aspectRatio,
                      url: imageUrl,
                      isThatImage: !isThatVideo,
                    );
                  } else {
                    String? mimeType = lookupMimeType(selectedImages[index].path);
                    return MemoryDisplay(
                      imagePath: selectedImages[index].readAsBytesSync(),
                      isThatImage: mimeType!.startsWith('image/'),
                    );
                  }
                },
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  aspectRatio: widget.aspectRatio,
                  onPageChanged: (index, reason) {
                    countOpacity.value = 1;
                    initPosition.value = index;
                    widget.updateImageIndex(index, reason);
                  },
                ),
              ),
              if (widget.showPointsScrollBar && minimumWidth)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: PointsScrollBar(
                      photoCount: widget.imagesUrls.length,
                      activePhotoIndex: initPositionValue,
                      makePointsWhite: true,
                    ),
                  ),
                ),
              if (!isThatMobile) ...[
                if (initPositionValue != 0)
                  GestureDetector(
                      onTap: () {
                        initPosition.value--;
                        _controller.animateToPage(initPosition.value,
                            curve: Curves.easeInOut);
                      },
                      child: const ArrowJump()),
                if (initPositionValue < widget.imagesUrls.length - 1)
                  GestureDetector(
                    onTap: () {
                      initPosition.value++;
                      _controller.animateToPage(initPosition.value,
                          curve: Curves.easeInOut);
                    },
                    child: const ArrowJump(isThatBack: false),
                  ),
              ],
              slideCount(),
            ],
          ),
        ),
      ),
    );
  }

  Widget slideCount() {
    return ValueListenableBuilder(
      valueListenable: countOpacity,
      builder: (context, double countOpacityValue, child) {
        if (countOpacityValue == 1) {
          Future.delayed(const Duration(seconds: 5), () {
            countOpacity.value = 0;
          });
        }
        return AnimatedOpacity(
          opacity: countOpacityValue,
          duration: const Duration(milliseconds: 200),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsetsDirectional.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25),
                ),
                height: 23,
                width: 35,
                child: Center(
                  child: ValueListenableBuilder(
                    valueListenable: initPosition,
                    builder: (context, int initPositionValue, child) => Text(
                      '${initPositionValue + 1}/${widget.imagesUrls.length}',
                      style: FlutterFlowTheme.of(context).bodyText1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
