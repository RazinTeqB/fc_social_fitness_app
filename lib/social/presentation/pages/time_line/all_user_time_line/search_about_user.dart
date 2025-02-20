import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/searchAboutUser/search_about_user_bloc.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';

class SearchAboutUserPage extends StatefulWidget {
  const SearchAboutUserPage({Key? key}) : super(key: key);

  @override
  State<SearchAboutUserPage> createState() => _SearchAboutUserPageState();
}

class _SearchAboutUserPageState extends State<SearchAboutUserPage> {
  final ValueNotifier<TextEditingController> _textController =
      ValueNotifier(TextEditingController());

  @override
  void dispose() {
    _textController.value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: isThatMobile ? buildAppBar(context) : null,
      body: BlocBuilder<SearchAboutUserBloc, SearchAboutUserState>(
        bloc: BlocProvider.of<SearchAboutUserBloc>(context)
          ..add(FindSpecificUser(_textController.value.text)),
        buildWhen: (previous, current) =>
            previous != current && (current is SearchAboutUserBlocLoaded),
        builder: (context, state) {
          if (state is SearchAboutUserBlocLoaded) {
            List<UserPersonalInfo> stateUsersInfo = state.users;

            return ListView.separated(
                itemBuilder: (context, index) {
                  String hash = "${stateUsersInfo[index].userId.hashCode}";
                  return ListTile(
                    title: Text(stateUsersInfo[index].userName,
                        style: FlutterFlowTheme.of(context).bodyText1),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stateUsersInfo[index].name,
                            style: FlutterFlowTheme.of(context).bodyText1),
                        if (stateUsersInfo[index]
                            .followerPeople
                            .contains(myPersonalId)) ...[
                          Text(FFLocalizations.of(context).getText(StringsManager.youFollowHim),
                              style: FlutterFlowTheme.of(context).bodyText1),
                        ] else if (stateUsersInfo[index]
                            .followedPeople
                            .contains(myPersonalId)) ...[
                          Text(FFLocalizations.of(context).getText(StringsManager.followers),
                              style: FlutterFlowTheme.of(context).bodyText1),
                        ],
                      ],
                    ),
                    leading: CircleAvatarOfProfileImage(
                        bodyHeight: bodyHeight * 0.85,
                        hashTag: hash,
                        userInfo: stateUsersInfo[index],
                      ),

                    onTap: () {
                      pushToPage(context,
                          page: WhichProfilePage(
                              userId: stateUsersInfo[index].userId),
                          withoutRoot: false);
                    },
                  );
                },
                itemCount:
                    //  _textController.text.isEmpty?0:
                    stateUsersInfo.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                      height: 10,
                    ));
          } else {
            return buildCircularProgress();
          }
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new,
            size: 25,
            color: FlutterFlowTheme.of(context).primaryText),
        onPressed: () => Navigator.of(context).pop(),
      ),
      toolbarHeight: 100,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      elevation: 0,
      title: Container(
        width: double.infinity,
        height: 35,
        decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          style: FlutterFlowTheme.of(context).bodyText1,
          controller: _textController.value,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
              contentPadding: const EdgeInsetsDirectional.only(bottom: 10, start: 10),
              hintText: FFLocalizations.of(context).getText(StringsManager.search),
              hintStyle:FlutterFlowTheme.of(context).bodyText1,
              border: InputBorder.none),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  Widget buildCircularProgress() => const ThineCircularProgress();
}
