import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'language_menu_item.widget.dart';


class AppLanguageSelector extends StatelessWidget {
  const AppLanguageSelector({required this.onSelected, Key? key}) : super(key: key);

  //
  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
          [
            //
            Text("Select your preferred language",style: FlutterFlowTheme.of(context).bodyText1,),

            //Arabic
            LanguageMenuItem(
              title: "Italiano",
              suffix: Flag.fromString('IT', height: 24, width: 24),
              onPressed: () => onSelected('it'),
              iconData: FontAwesomeIcons.arrowRight,
            ),
            //English
            LanguageMenuItem(
              title: "English",
              suffix: Flag.fromString('US', height: 24, width: 24),
              onPressed: () => onSelected('en'),
              iconData: FontAwesomeIcons.arrowRight,
            ),
            /* //French
            MenuItem(
              title: "French",
              suffix: Flag('FR', height: 24, width: 24),
              onPressed: () => onSelected('fr'),
            ),
            //Spanish
            MenuItem(
              title: "Spanish",
              suffix: Flag('ES', height: 24, width: 24),
              onPressed: () => onSelected('es'),
            ),
            //German
            MenuItem(
              title: "German",
              suffix: Flag('DE', height: 24, width: 24),
              onPressed: () => onSelected('de'),
            ),
            //Portuguese
            MenuItem(
              title: "Portuguese",
              suffix: Flag('PT', height: 24, width: 24),
              onPressed: () => onSelected('pt'),
            ),
            //Korean
            MenuItem(
              title: "Korean",
              suffix: Flag('KR', height: 24, width: 24),
              onPressed: () => onSelected('ko'),
            ),*/

            //ADD YOUR CUSTOM LANGUAGE HERE
            // MenuItem(
            //   title: "LANGUAGE_NAME",
            //   suffix: Flag('COUNRTY_CODE', height: 24, width: 24),
            //   onPressed: () => onSelected('LANGUAGE_CODE'),
            // ),
          ],
        ),
      );
  }
}