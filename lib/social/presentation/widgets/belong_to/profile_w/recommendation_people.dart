import 'package:flutter/material.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';

class RecommendationPeople extends StatelessWidget {
  const RecommendationPeople({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 35.0,
        width: 35,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryColor,
          border: Border.all(
              color: FlutterFlowTheme.of(context).primaryText, width: 1.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Icon(Icons.person_add_outlined,
              color: FlutterFlowTheme.of(context).primaryColor),
        ),
      ),
    );
  }
}
