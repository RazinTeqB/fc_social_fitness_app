import 'package:cached_network_image/cached_network_image.dart';
import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/presentation/pages/video/play_this_video.dart';

// ignore: depend_on_referenced_packages
import 'package:photo_view/photo_view.dart';

class NetworkDisplay extends StatefulWidget {
  final int cachingHeight, cachingWidth;
  final String url;
  final double aspectRatio;
  final bool isThatImage;
  final double? height;

  const NetworkDisplay({
    Key? key,
    required this.url,
    this.isThatImage = true,
    this.cachingHeight = 1080,
    this.cachingWidth = 1080,
    this.height,
    this.aspectRatio = 0,
  }) : super(key: key);

  @override
  State<NetworkDisplay> createState() => _NetworkDisplayState();
}

class _NetworkDisplayState extends State<NetworkDisplay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.isThatImage && widget.url.isNotEmpty) {
      precacheImage(NetworkImage(widget.url), context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.aspectRatio == 0 ? whichBuild(height: null) : aspectRatio();
  }

  Widget aspectRatio() {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: whichBuild(),
    );
  }

  Widget whichBuild({double? height = double.infinity}) {
    return !widget.isThatImage
        ? PlayThisVideo(
            play: true,
            videoUrl: widget.url,
          )
        : buildOcto(height);
  }

  Widget buildOcto(height) {
    int cachingHeight = widget.cachingHeight;
    int cachingWidth = widget.cachingWidth;
    if (widget.aspectRatio != 1 && cachingHeight == 720) cachingHeight = 960;
    return GestureDetector(
        onTap: () async {
          await showDialog(
            context: context,
            builder: (_) => TutorialOverlay(
                imageUrl: widget.url, cachingHeight: 1080, cachingWidth: 1080,
               ),
          );
        },
        child: CachedNetworkImage(
          imageUrl: widget.url,
          height: widget.height ?? height,
          width: double.infinity,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => Center(child: loadingWidget()),
          errorWidget: (context, url, error) => Center(child: loadingWidget()),
        ));
  }

  Widget loadingWidget() {
    double aspectRatio = widget.aspectRatio;
    return aspectRatio == 0
        ? buildSizedBox()
        : AspectRatio(
            aspectRatio: aspectRatio,
            child: buildSizedBox(),
          );
  }

  Widget buildSizedBox() {
    return Container(
      width: double.infinity,
      color: FlutterFlowTheme.of(context).primaryBackground,
      child: Center(
          child: CircularProgressIndicator(
        strokeWidth: 2,
        color: FlutterFlowTheme.of(context).primaryText,
      )),
    );
  }
}

class TutorialOverlay extends StatelessWidget {
  const TutorialOverlay({
    super.key,
    required this.imageUrl,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    required this.cachingHeight,
    required this.cachingWidth,
  });

  final String imageUrl;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int cachingHeight;
  final int cachingWidth;

  @override
  Widget build(BuildContext context) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: _buildOverlayContent(context),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: PhotoView(
            imageProvider: CachedNetworkImageProvider(imageUrl,
                maxWidth: cachingWidth, maxHeight: cachingHeight),
            backgroundDecoration: backgroundDecoration,
            minScale: minScale,
            maxScale: maxScale,
          ),
        ));
  }
}
