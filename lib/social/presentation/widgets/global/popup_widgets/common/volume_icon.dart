import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';

class VolumeIcon extends StatelessWidget {
  final bool isVolumeOn;

  const VolumeIcon({Key? key, this.isVolumeOn = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon = isVolumeOn ? Icons.volume_up : Icons.volume_off;
    return buildContainer(icon);
  }

  Container buildContainer(IconData icon) {
    return Container(
      height: 30,
      width: 30,
      padding: const EdgeInsetsDirectional.all(1),
      decoration: BoxDecoration(
        color: ColorManager.black54,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Center(
        child: Icon(icon, color: ColorManager.white, size: 20),
      ),
    );
  }
}
