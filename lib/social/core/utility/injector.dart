import 'package:fc_social_fitness/social/domain/use_cases/message/group_message/delete_chat.dart';
import 'package:get_it/get_it.dart';
import 'package:fc_social_fitness/social/data/repositories_impl/calling_rooms_repo_impl.dart';
import 'package:fc_social_fitness/social/data/repositories_impl/firebase_auth_repository_impl.dart';
import 'package:fc_social_fitness/social/data/repositories_impl/firestore_notification.dart';
import 'package:fc_social_fitness/social/data/repositories_impl/firestore_user_repo_impl.dart';
import 'package:fc_social_fitness/social/data/repositories_impl/group_message_repo_impl.dart';
import 'package:fc_social_fitness/social/data/repositories_impl/post/comment/firestore_comment_repo_impl.dart';
import 'package:fc_social_fitness/social/data/repositories_impl/post/comment/firestore_reply_repo_impl.dart';
import 'package:fc_social_fitness/social/data/repositories_impl/post/firestore_post_repo_impl.dart';
import 'package:fc_social_fitness/social/domain/repositories/auth_repository.dart';
import 'package:fc_social_fitness/social/domain/repositories/calling_rooms_repository.dart';
import 'package:fc_social_fitness/social/domain/repositories/firestore_notification.dart';
import 'package:fc_social_fitness/social/domain/repositories/group_message.dart';
import 'package:fc_social_fitness/social/domain/repositories/post/comment/comment_repository.dart';
import 'package:fc_social_fitness/social/domain/repositories/post/comment/reply_repository.dart';
import 'package:fc_social_fitness/social/domain/repositories/post/post_repository.dart';
import 'package:fc_social_fitness/social/domain/repositories/user_repository.dart';
import 'package:fc_social_fitness/social/domain/use_cases/auth/log_in_auth_usecase.dart';
import 'package:fc_social_fitness/social/domain/use_cases/auth/sign_out_auth_usecase.dart';
import 'package:fc_social_fitness/social/domain/use_cases/auth/sign_up_auth_usecase.dart';
import 'package:fc_social_fitness/social/domain/use_cases/calling_rooms/cancel_joining_to_room.dart';
import 'package:fc_social_fitness/social/domain/use_cases/calling_rooms/create_calling_room.dart';
import 'package:fc_social_fitness/social/domain/use_cases/calling_rooms/delete_the_room.dart';
import 'package:fc_social_fitness/social/domain/use_cases/calling_rooms/get_calling_status.dart';
import 'package:fc_social_fitness/social/domain/use_cases/calling_rooms/get_users_info_in_room.dart';
import 'package:fc_social_fitness/social/domain/use_cases/calling_rooms/join_to_calling_room.dart';
import 'package:fc_social_fitness/social/domain/use_cases/follow/follow_this_user.dart';
import 'package:fc_social_fitness/social/domain/use_cases/follow/remove_this_follower.dart';
import 'package:fc_social_fitness/social/domain/use_cases/message/common/get_specific_chat_info.dart';
import 'package:fc_social_fitness/social/domain/use_cases/message/group_message/add_message.dart';
import 'package:fc_social_fitness/social/domain/use_cases/message/group_message/delete_message.dart';
import 'package:fc_social_fitness/social/domain/use_cases/message/group_message/get_messages.dart';
import 'package:fc_social_fitness/social/domain/use_cases/message/single_message/add_message.dart';
import 'package:fc_social_fitness/social/domain/use_cases/message/single_message/delete_message.dart';
import 'package:fc_social_fitness/social/domain/use_cases/message/single_message/get_chat_users_info.dart';
import 'package:fc_social_fitness/social/domain/use_cases/message/single_message/get_messages.dart';
import 'package:fc_social_fitness/social/domain/use_cases/notification/create_notification_use_case.dart';
import 'package:fc_social_fitness/social/domain/use_cases/notification/delete_notification.dart';
import 'package:fc_social_fitness/social/domain/use_cases/notification/get_notifications_use_case.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/comments/add_comment_use_case.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/comments/getComment/get_all_comment.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/comments/put_like.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/comments/remove_like.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/comments/replies/get_replies_of_this_comment.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/comments/replies/likes/put_like_on_this_reply.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/comments/replies/likes/remove_like_on_this_reply.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/comments/replies/reply_on_this_comment.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/create_post.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/delete/delete_post.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/get/get_all_posts.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/get/get_post_info.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/get/get_specific_users_posts.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/likes/put_like_on_this_post.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/likes/remove_the_like_on_this_post.dart';
import 'package:fc_social_fitness/social/domain/use_cases/post/update/update_post.dart';

import 'package:fc_social_fitness/social/domain/use_cases/user/add_new_user_usecase.dart';
import 'package:fc_social_fitness/social/domain/use_cases/user/add_post_to_user.dart';
import 'package:fc_social_fitness/social/domain/use_cases/user/getUserInfo/get_all_un_followers_info.dart';
import 'package:fc_social_fitness/social/domain/use_cases/user/getUserInfo/get_all_users_info.dart';
import 'package:fc_social_fitness/social/domain/use_cases/user/getUserInfo/get_followers_and_followings_usecase.dart';
import 'package:fc_social_fitness/social/domain/use_cases/user/getUserInfo/get_specific_users_usecase.dart';
import 'package:fc_social_fitness/social/domain/use_cases/user/getUserInfo/get_user_from_user_name.dart';
import 'package:fc_social_fitness/social/domain/use_cases/user/getUserInfo/get_user_info_usecase.dart';
import 'package:fc_social_fitness/social/domain/use_cases/user/my_personal_info.dart';
import 'package:fc_social_fitness/social/domain/use_cases/user/search_about_user.dart';
import 'package:fc_social_fitness/social/domain/use_cases/user/update_user_info.dart';
import 'package:fc_social_fitness/social/domain/use_cases/user/upload_profile_image_usecase.dart';
import 'package:fc_social_fitness/social/presentation/cubit/callingRooms/bloc/calling_status_bloc.dart';
import 'package:fc_social_fitness/social/presentation/cubit/callingRooms/calling_rooms_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/add_new_user_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/message/cubit/group_chat/message_for_group_chat_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/searchAboutUser/search_about_user_bloc.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/users_info_reel_time/users_info_reel_time_bloc.dart';
import 'package:fc_social_fitness/social/presentation/cubit/follow/follow_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/notification/notification_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/commentsInfo/cubit/comment_likes/comment_likes_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/commentsInfo/cubit/comments_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/replyLikes/reply_likes_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/postLikes/post_likes_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/specific_users_posts_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/use_cases/message/single_message/delete_chat.dart';

final injector = GetIt.I;

Future<void> initializeDependencies() async {
  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();

  injector.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // Repository

  // Post
  injector.registerSingleton<FireStorePostRepository>(
    FireStorePostRepositoryImpl(),
  );
  // comment
  injector.registerSingleton<FirestoreCommentRepository>(
    FirestoreCommentRepositoryImpl(),
  );
  //reply

  injector.registerSingleton<FirestoreReplyRepository>(
    FirestoreRepliesRepositoryImpl(),
  );
  // *
  // *
  // *
  injector.registerSingleton<FirebaseAuthRepository>(
    FirebaseAuthRepositoryImpl(),
  );
  injector.registerSingleton<FirestoreUserRepository>(
    FirebaseUserRepoImpl(),
  );
  // notification
  injector.registerSingleton<FirestoreNotificationRepository>(
    FirestoreNotificationRepoImpl(),
  );
  // calling rooms repository
  injector.registerSingleton<CallingRoomsRepository>(CallingRoomsRepoImpl());

  injector.registerSingleton<FirestoreGroupMessageRepository>(
      FirebaseGroupMessageRepoImpl());

  // *
  /// ==============================================================================================>

  // Firebase auth useCases
  injector.registerSingleton<LogInAuthUseCase>(LogInAuthUseCase(injector()));

  injector.registerSingleton<SignUpAuthUseCase>(SignUpAuthUseCase(injector()));
  injector
      .registerSingleton<SignOutAuthUseCase>(SignOutAuthUseCase(injector()));
  // *
  // Firestore user useCases
  injector.registerSingleton<AddNewUserUseCase>(AddNewUserUseCase(injector()));

  injector
      .registerSingleton<GetUserInfoUseCase>(GetUserInfoUseCase(injector()));

  injector.registerSingleton<GetFollowersAndFollowingsUseCase>(
      GetFollowersAndFollowingsUseCase(injector()));

  injector.registerSingleton<UpdateUserInfoUseCase>(
      UpdateUserInfoUseCase(injector()));

  injector.registerSingleton<UploadProfileImageUseCase>(
      UploadProfileImageUseCase(injector()));

  injector.registerSingleton<GetSpecificUsersUseCase>(
      GetSpecificUsersUseCase(injector()));

  injector.registerSingleton<AddPostToUserUseCase>(
      AddPostToUserUseCase(injector()));

  injector.registerSingleton<GetUserFromUserNameUseCase>(
      GetUserFromUserNameUseCase(injector()));
  injector.registerSingleton<GetAllUnFollowersUseCase>(
      GetAllUnFollowersUseCase(injector()));

  injector.registerSingleton<SearchAboutUserUseCase>(
      SearchAboutUserUseCase(injector()));

  injector.registerSingleton<GetChatUsersInfoAddMessageUseCase>(
      GetChatUsersInfoAddMessageUseCase(injector()));

  injector.registerSingleton<GetMyInfoUseCase>(GetMyInfoUseCase(injector()));

  // message use case
  injector.registerSingleton<AddMessageUseCase>(AddMessageUseCase(injector()));
  injector
      .registerSingleton<GetMessagesUseCase>(GetMessagesUseCase(injector()));
  injector.registerSingleton<DeleteMessageUseCase>(
      DeleteMessageUseCase(injector()));
  injector.registerSingleton<DeleteChatUseCase>(
      DeleteChatUseCase(injector()));
  // *
  // *
  // Firestore Post useCases
  injector.registerSingleton<CreatePostUseCase>(CreatePostUseCase(injector()));
  injector
      .registerSingleton<GetPostsInfoUseCase>(GetPostsInfoUseCase(injector()));

  injector.registerSingleton<GetAllPostsInfoUseCase>(
      GetAllPostsInfoUseCase(injector()));

  injector.registerSingleton<GetSpecificUsersPostsUseCase>(
      GetSpecificUsersPostsUseCase(injector()));

  injector.registerSingleton<PutLikeOnThisPostUseCase>(
      PutLikeOnThisPostUseCase(injector()));

  injector.registerSingleton<RemoveTheLikeOnThisPostUseCase>(
      RemoveTheLikeOnThisPostUseCase(injector()));

  injector.registerSingleton<DeletePostUseCase>(DeletePostUseCase(injector()));

  injector.registerSingleton<UpdatePostUseCase>(UpdatePostUseCase(injector()));
  //Firestore Comment UseCase
  injector.registerSingleton<GetSpecificCommentsUseCase>(
      GetSpecificCommentsUseCase(injector()));

  injector.registerSingleton<AddCommentUseCase>(AddCommentUseCase(injector()));

  injector.registerSingleton<PutLikeOnThisCommentUseCase>(
      PutLikeOnThisCommentUseCase(injector()));

  injector.registerSingleton<RemoveLikeOnThisCommentUseCase>(
      RemoveLikeOnThisCommentUseCase(injector()));

  //Firestore reply UseCase
  injector.registerSingleton<PutLikeOnThisReplyUseCase>(
      PutLikeOnThisReplyUseCase(injector()));

  injector.registerSingleton<RemoveLikeOnThisReplyUseCase>(
      RemoveLikeOnThisReplyUseCase(injector()));

  injector.registerSingleton<GetRepliesOfThisCommentUseCase>(
      GetRepliesOfThisCommentUseCase(injector()));

  injector.registerSingleton<ReplyOnThisCommentUseCase>(
      ReplyOnThisCommentUseCase(injector()));
  // *
  // *

  // follow useCases
  injector.registerSingleton<FollowThisUserUseCase>(
      FollowThisUserUseCase(injector()));
  injector.registerSingleton<UnFollowThisUserUseCase>(
      UnFollowThisUserUseCase(injector()));

  // *

  // *
  // notification useCases
  injector.registerSingleton<GetNotificationsUseCase>(
      GetNotificationsUseCase(injector()));
  injector.registerSingleton<CreateNotificationUseCase>(
      CreateNotificationUseCase(injector()));
  injector.registerSingleton<DeleteNotificationUseCase>(
      DeleteNotificationUseCase(injector()));
  // *
  // calling rooms useCases
  injector.registerSingleton<CreateCallingRoomUseCase>(
      CreateCallingRoomUseCase(injector()));
  // join room useCases
  injector.registerSingleton<JoinToCallingRoomUseCase>(
      JoinToCallingRoomUseCase(injector()));
  // cancel room useCases
  injector.registerSingleton<CancelJoiningToRoomUseCase>(
      CancelJoiningToRoomUseCase(injector()));
  injector.registerSingleton<GetCallingStatusUseCase>(
      GetCallingStatusUseCase(injector()));

  injector.registerSingleton<GetUsersInfoInRoomUseCase>(
      GetUsersInfoInRoomUseCase(injector()));

  injector.registerSingleton<DeleteTheRoomUseCase>(
      DeleteTheRoomUseCase(injector()));

  injector
      .registerSingleton<GetAllUsersUseCase>(GetAllUsersUseCase(injector()));

  injector.registerSingleton<DeleteMessageForGroupChatUseCase>(
      DeleteMessageForGroupChatUseCase(injector()));

  injector.registerSingleton<GetMessagesGroGroupChatUseCase>(
      GetMessagesGroGroupChatUseCase(injector()));

  injector.registerSingleton<AddMessageForGroupChatUseCase>(
      AddMessageForGroupChatUseCase(injector()));

  injector
      .registerSingleton<GetSpecificChatInfo>(GetSpecificChatInfo(injector()));

  /// ==============================================================================================>

  // auth Blocs
  injector.registerFactory<FirebaseAuthCubit>(
    () => FirebaseAuthCubit(injector(), injector(), injector()),
  );
  // *

  // user Blocs
  injector.registerFactory<FirestoreAddNewUserCubit>(
    () => FirestoreAddNewUserCubit(injector()),
  );
  injector.registerFactory<UserInfoCubit>(() => UserInfoCubit(
        injector(),
        injector(),
        injector(),
        injector(),
        injector(),
        injector(),
      ));

  injector.registerFactory<UsersInfoCubit>(
    () => UsersInfoCubit(injector(), injector(), injector()),
  );

  injector.registerFactory<SearchAboutUserBloc>(
      () => SearchAboutUserBloc(injector()));

  injector.registerFactory<UsersInfoReelTimeBloc>(
      () => UsersInfoReelTimeBloc(injector(), injector()));

  // message searchAboutUser
  injector.registerFactory<MessageCubit>(
    () => MessageCubit(injector(), injector(), injector(),injector()),
  );
  injector.registerFactory<MessageBloc>(
    () => MessageBloc(injector(), injector()),
  );
  // *
  // *

  // follow Blocs
  injector.registerFactory<FollowCubit>(
    () => FollowCubit(injector(), injector()),
  );
  // *

  // post likes searchAboutUser
  injector.registerFactory<PostLikesCubit>(
    () => PostLikesCubit(injector(), injector()),
  );
  // *

  // comment searchAboutUser
  injector.registerFactory<CommentsInfoCubit>(
    () => CommentsInfoCubit(injector(), injector()),
  );
  injector.registerFactory<CommentLikesCubit>(
    () => CommentLikesCubit(injector(), injector()),
  );

  // *
  // post Blocs
  injector.registerFactory<ReplyInfoCubit>(
    () => ReplyInfoCubit(injector(), injector()),
  );
  injector.registerFactory<ReplyLikesCubit>(
    () => ReplyLikesCubit(injector(), injector()),
  );
  // *

  // post Blocs
  injector.registerFactory<PostCubit>(
    () => PostCubit(injector(), injector(), injector(), injector(), injector()),
  );
  injector.registerFactory<SpecificUsersPostsCubit>(
    () => SpecificUsersPostsCubit(injector()),
  );
  // *
  // notification Blocs
  injector.registerFactory<NotificationCubit>(
    () => NotificationCubit(injector(), injector(), injector()),
  );
  // *
  // calling rooms cubit
  injector.registerFactory<CallingRoomsCubit>(
    () => CallingRoomsCubit(
      injector(),
      injector(),
      injector(),
      injector(),
      injector(),
    ),
  );
  injector
      .registerFactory<CallingStatusBloc>(() => CallingStatusBloc(injector()));

  injector.registerFactory<MessageForGroupChatCubit>(
      () => MessageForGroupChatCubit(injector(), injector(),injector()));
  injector.registerSingleton<DeleteChatForGroupChatUseCase>(
      DeleteChatForGroupChatUseCase(injector()));
  // *
}
