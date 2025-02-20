import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/comments_w/comment_of_post.dart';

import '../../../../utils/flutter_flow_theme.util.dart';

class CommentsPageForMobile extends StatefulWidget {
  final ValueNotifier<Post> postInfo;

  const CommentsPageForMobile({Key? key, required this.postInfo})
      : super(key: key);

  @override
  State<CommentsPageForMobile> createState() => _CommentsPageForMobileState();
}

class _CommentsPageForMobileState extends State<CommentsPageForMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: isThatMobile ? appBar(context) : null,
      body: CommentsOfPost(
        postInfo: widget.postInfo,
        selectedCommentInfo: ValueNotifier(null),
        textController: ValueNotifier(TextEditingController()),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new,
            size: 25,
            color: FlutterFlowTheme.of(context).primaryText),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      title: Text(
        StringsManager.comments,
        style: FlutterFlowTheme.of(context).title3,
      ),
    );
  }
}
