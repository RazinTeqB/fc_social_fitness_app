import 'package:flutter/material.dart';

import '../../utils/flutter_flow_theme.util.dart';

class OnboardingTile extends StatelessWidget {
  final title, imagePath, mainText;

  OnboardingTile({this.imagePath, this.mainText, this.title});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 34),
          Expanded(
            child: Image.asset(
              imagePath,
            ),
          ),
          const SizedBox(height: 65),
          Text(
            title,
            style: FlutterFlowTheme.of(context).title1,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth / 100,
            ),
            child: Text(
              mainText,
              style: FlutterFlowTheme.of(context).bodyText1,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
