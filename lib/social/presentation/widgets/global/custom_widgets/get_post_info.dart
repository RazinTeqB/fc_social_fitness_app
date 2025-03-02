import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/comments_w/comment_of_post.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_posts_display.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/others/image_of_post.dart';

class GetsPostInfoAndDisplay extends StatelessWidget {
  final String postId;
  final String appBarText;
  final bool fromHeroRoute;
  const GetsPostInfoAndDisplay({
    Key? key,
    required this.postId,
    required this.appBarText,
    this.fromHeroRoute = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isThatMobile
          ? CustomAppBar.oneTitleAppBar(context, appBarText,
              logoOfInstagram: true)
          : null,
      body: BlocBuilder<PostCubit, PostState>(
        bloc: PostCubit.get(context)
          ..getPostsInfo(postsIds: [postId], isThatMyPosts: false),
        buildWhen: (previous, current) {
          if (previous != current && current is CubitPostFailed) {
            return true;
          }
          return previous != current && current is CubitPostsInfoLoaded;
        },
        builder: (context, state) {
          if (state is CubitPostsInfoLoaded) {
            if (isThatMobile) {
              if (state.postsInfo.isNotEmpty &&
                  state.postsInfo[0].comments.length < 10) {
                return CommentsOfPost(
                  postInfo: ValueNotifier(state.postsInfo[0]),
                  textController: ValueNotifier(TextEditingController()),
                  selectedCommentInfo: ValueNotifier(null),
                  showImage: true,
                );
              } else {
                return CustomPostsDisplay(
                  postsInfo: state.postsInfo,
                  showCatchUp: false,
                );
              }
            } else {
              return ImageOfPost(
                postInfo: ValueNotifier(state.postsInfo[0]),
                textController: ValueNotifier(TextEditingController()),
                selectedCommentInfo: ValueNotifier(null),
                playTheVideo: true,
                indexOfPost: 0,
                postsInfo: ValueNotifier(state.postsInfo),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: Theme.of(context).iconTheme.color,
                backgroundColor: Theme.of(context).dividerColor,
              ),
            );
          }
        },
      ),
    );
  }
}
