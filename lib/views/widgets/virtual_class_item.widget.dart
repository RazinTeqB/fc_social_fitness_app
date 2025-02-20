import 'package:fc_social_fitness/models/virtualclass.model.dart';
import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class VirtualClassItem extends StatelessWidget {
  const VirtualClassItem({
    Key? key,
    required this.virtualClass,
    required this.onPressed
  }) : super(key: key);

  final VirtualClass virtualClass;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    //todo aggiustare i guai
    return Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: onPressed,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child:Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //vendor name
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              virtualClass.name.toString(),
                              style: FlutterFlowTheme.of(context).title3,
                            ),
                          ),
                          //rating, deliver fee
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Creata da @${virtualClass.user?.username}",
                              style: FlutterFlowTheme.of(context).bodyText1,
                            ),
                          ),
                          //rating, deliver fee
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Aggiunto il "+ DateFormat.yMd("it").format(virtualClass.createdAt!),
                              style: FlutterFlowTheme.of(context).bodyText1,

                            ),
                          ),
                          /*Expanded(
                            child: Text(
                              ebike.blueDevice != null ?"Connesso":"NON connesso",
                              style: AppTextStyle.h5TitleTextStyle(
                                color: AppColor.textColor(context),
                              ),
                            ),
                          ),*/
                          //rating, deliver fee
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}