import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FitnessLoading extends StatelessWidget {
  const FitnessLoading({Key? key, this.animation, this.size = 0.8})
      : super(key: key);
  final String? animation;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        child: Center(
          child: LottieBuilder.asset(
            FlutterFlowTheme.of(context).loadingAnimation,
            width: MediaQuery.of(context).size.width * size,
          ),
        ));
  }
}
