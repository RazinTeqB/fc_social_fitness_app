import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../constants/app_routes.dart';
import '../../utils/flutter_flow_theme.util.dart';
import '../../viewmodels/base.viewmodel.dart';

class OnboardingPageWidget extends StatefulWidget {
  const OnboardingPageWidget(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.body,
      required this.onNext,
      required this.pageIndex})
      : super(key: key);
  final String imagePath;
  final String title;
  final String body;
  final int pageIndex;
  final Function()? onNext;

  @override
  State<OnboardingPageWidget> createState() => _OnboardingPageWidgetState();
}

class _OnboardingPageWidgetState extends State<OnboardingPageWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Image.asset(widget.imagePath, fit: BoxFit.fill),
          Positioned(
            bottom: 50,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: FlutterFlowTheme.of(context)
                        .title3
                        .merge(const TextStyle(color: Colors.black)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          widget.body,
                          style: FlutterFlowTheme.of(context)
                              .bodyText1
                              .merge(const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Imposta una dimensione del font più piccola
                          )),
                          minFontSize: 10, // Imposta una dimensione minima del font
                          stepGranularity: 1, // Regola l'incremento del ridimensionamento
                          overflow: TextOverflow.visible, // Evita i puntini di sospensione
                        ),
                      ),
                      const SizedBox(width: 15),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: _getPercent(widget.pageIndex - 1),
                          end: _getPercent(widget.pageIndex),
                        ),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, _) =>
                            CircularPercentIndicator(
                              radius: 32,
                              backgroundColor: FlutterFlowTheme.of(context).course20,
                              progressColor: FlutterFlowTheme.of(context).grey,
                              percent: 1 - value,
                              center: Material(
                                shape: CircleBorder(),
                                color: FlutterFlowTheme.of(context).course20,
                                child: RawMaterialButton(
                                  shape: const CircleBorder(),
                                  onPressed: widget.onNext,
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 25.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    /*return Stack(children: [
      Image.asset(widget.imagePath, fit: BoxFit.fill),
      Positioned(
          bottom: 50,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: FlutterFlowTheme.of(context)
                          .title3
                          .merge(TextStyle(color: Colors.black)),
                    ),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                              child: AutoSizeText(
                            widget.body,
                            style: FlutterFlowTheme.of(context)
                                .bodyText1
                                .merge(TextStyle(color: Colors.black)),
                          )),
                          SizedBox(width: 15),
                          TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                  begin: _getPercent(widget.pageIndex - 1),
                                  end: _getPercent(widget.pageIndex)),
                              duration: const Duration(seconds: 1),
                              builder: (context, value, _) =>
                                  CircularPercentIndicator(
                                    radius: 32,
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).course20,
                                    progressColor:
                                        FlutterFlowTheme.of(context).grey,
                                    percent: 1 - value,
                                    center: Material(
                                      shape: CircleBorder(),
                                      color:
                                          FlutterFlowTheme.of(context).course20,
                                      child: RawMaterialButton(
                                        shape: const CircleBorder(),
                                        onPressed: widget.onNext,
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 25.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )),
                        ])
                  ])))
    ]);*/
  }

  double _getPercent(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return 0.0;
      case 1:
        return 0.5;
      case 2:
        return 1;
      default:
        return 0;
    }
  }
}
