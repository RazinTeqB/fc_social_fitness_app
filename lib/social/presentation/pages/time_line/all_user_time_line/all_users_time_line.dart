import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:fc_social_fitness/social/presentation/pages/time_line/all_user_time_line/search_about_user.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/time_line_w/all_time_line_grid_view.dart';
import 'package:fc_social_fitness/social/core/functions/toast_show.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';

class AllUsersTimeLinePage extends StatelessWidget {
  final ValueNotifier<bool> rebuildUsersInfo = ValueNotifier(false);
  final ValueNotifier<bool> isThatEndOfList = ValueNotifier(false);
  final ValueNotifier<bool> reloadData = ValueNotifier(true);

  AllUsersTimeLinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    rebuildUsersInfo.value = false;
    return WillPopScope(
      onWillPop: () async => true,
      child: SafeArea(
          child: Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: blocBuilder(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: searchAppBar(context),
                ),
              ],
            )),
      )),
    );
  }

  Widget searchAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: TextField(
          maxLines: 1,
          textAlign: TextAlign.start,
          onTap: () {
            pushToPage(context, page: const SearchAboutUserPage());
          },
          readOnly: true,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top:6),
              prefixIcon: Icon(Icons.search_rounded,
                  color: FlutterFlowTheme.of(context).primaryText),
              hintText: FFLocalizations.of(context).getText(StringsManager.search),
              hintStyle: FlutterFlowTheme.of(context).bodyText1,
              border: InputBorder.none),
        ),
      ),
    );
  }

  Future<void> getData(BuildContext context, int index) async {
    await BlocProvider.of<PostCubit>(context).getAllPostInfo();
    rebuildUsersInfo.value = true;
    reloadData.value = true;
  }

  ValueListenableBuilder<bool> blocBuilder() {
    return ValueListenableBuilder(
      valueListenable: rebuildUsersInfo,
      builder: (context, bool value, child) =>
          BlocBuilder<PostCubit, PostState>(
        bloc: BlocProvider.of<PostCubit>(context)..getAllPostInfo(),
        buildWhen: (previous, current) {
          if (previous != current && current is CubitAllPostsLoaded) {
            return true;
          }
          if (value && current is CubitAllPostsLoaded) {
            rebuildUsersInfo.value = false;
            return true;
          }
          return false;
        },
        builder: (BuildContext context, state) {
          if (state is CubitAllPostsLoaded) {
            List<Post> imagePosts = [];
            List<Post> videoPosts = [];

            for (Post element in state.allPostInfo) {
              bool isThatImage = element.isThatMix || element.isThatImage;
              isThatImage ? imagePosts.add(element) : videoPosts.add(element);
            }

            return Center(
              child: SizedBox(
                width: isThatMobile ? null : 910,
                child: AllTimeLineGridView(
                  onRefreshData: (int index) => getData(context, index),
                  postsImagesInfo: imagePosts,
                  postsVideosInfo: videoPosts,
                  isThatEndOfList: isThatEndOfList,
                  reloadData: reloadData,
                  allPostsInfo: state.allPostInfo,
                ),
              ),
            );
          } else if (state is CubitPostFailed) {
            ToastShow.toastStateError(state);
            return Center(
                child: Text(
                  FFLocalizations.of(context).getText(StringsManager.noPosts),
              style: FlutterFlowTheme.of(context).bodyText1,
            ));
          } else {
            return loadingWidget(context);
          }
        },
      ),
    );
  }

  Widget loadingWidget(BuildContext context) {
    return Center(
      child: SizedBox(
        width: isThatMobile ? null : 910,
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).textTheme.headlineSmall!.color!,
          highlightColor: Theme.of(context).textTheme.titleLarge!.color!,
          child: StaggeredGridView.countBuilder(
            crossAxisSpacing: isThatMobile ? 1.5 : 30,
            mainAxisSpacing: isThatMobile ? 1.5 : 30,
            crossAxisCount: 3,
            itemCount: 16,
            itemBuilder: (_, __) {
              return Container(
                  color: ColorManager.lightDarkGray, width: double.infinity);
            },
            staggeredTileBuilder: (index) {
              double num =
                  (index == 2 || (index % 11 == 0 && index != 0)) ? 2 : 1;
              return StaggeredTile.count(1, num);
            },
          ),
        ),
      ),
    );
  }
}
