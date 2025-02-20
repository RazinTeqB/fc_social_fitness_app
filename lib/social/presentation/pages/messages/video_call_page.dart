import 'dart:io';
import 'dart:math';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:fc_social_fitness/views/home.page.dart';
import 'package:fc_social_fitness/views/training_categories.page.dart';
import 'package:pip_view/pip_view.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

import '../../../../models/api_response.dart';
import '../../../../repositories/virtual_class.repository.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/resources/styles_manager.dart';
import '../../../core/utility/constant.dart';
import '../../../core/utility/private_keys.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../cubit/callingRooms/calling_rooms_cubit.dart';
import '../../cubit/firestoreUserInfoCubit/user_info_cubit.dart';

enum UserCallingType { sender, receiver }

class CallPage extends StatefulWidget {
  final String channelName;
  final String userCallingId;

  final List<UserPersonalInfo>? usersInfo;
  final UserCallingType userCallingType;
  final ClientRoleType role;

  const CallPage({
    Key? key,
    required this.channelName,
    this.userCallingId = "",
    required this.userCallingType,
    required this.role,
    this.usersInfo,
  }) : super(key: key);

  @override
  CallPageState createState() => CallPageState();
}

class CallPageState extends State<CallPage> {
  final _users = <VideoUser>[];
  final _infoStrings = <String>[];
  bool muted = true;
  bool video = true;

  bool moreThanOne = false;

  late RtcEngine _engine;
  late UserPersonalInfo myPersonalInfo;

  @override
  void dispose() {
    _users.clear();
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  void initState() {
    super.initState();
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async => await onJoin());
    initialize();
  }

  Future<void> onJoin() async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
  }

  Future<void> _handleCameraAndMic(Permission permission) async =>
      await permission.request();

  /// Create your own app id with agora with "testing mode"
  /// it's very simple, just go to https://www.agora.io/en/ and create your own project and get your own app id in [agoraAppId]
  /// Again, don't make it with secure mode ,You will lose the creation of several channels.
  /// Make it with "testing mode"
  Future<void> initialize() async {
    if (PrivateKeys.agoraAppId.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 1920, height: 1080));
    await _engine.setVideoEncoderConfiguration(configuration);
    VirtualClassRepository virtualClassRepository = VirtualClassRepository();
    int uid = Random().nextInt(10000);
    ApiResponse response = await virtualClassRepository.getAgoraToken(
        context, widget.channelName, uid.toString());
    await _engine.joinChannel(
        token: response.body["rtcToken"],
        channelId: widget.channelName,
        options: const ChannelMediaOptions(),
        uid: uid);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: PrivateKeys.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    await _engine.enableVideo();
    await _engine
        .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await _engine.setClientRole(role: widget.role);
  }

  void _addAgoraEventHandlers() {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {},
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {},
      onRemoteVideoStateChanged: (connection, uid, state, reason, elapsed) {
        print(state.name);
        if (state == RemoteVideoState.remoteVideoStateStopped) {
          setState(() {
            _users.where((element) => element.uid == uid).first.status = false;
          });
        } else if (state == RemoteVideoState.remoteVideoStateStarting) {
          setState(() {
            _users.where((element) => element.uid == uid).first.status = true;
          });
        }
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        setState(() {
          _users.add(VideoUser(rUid, true));
        });
      },
      onUserOffline:
          (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        setState(() {
          _users.removeWhere((element) => element.uid == rUid);
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        _users.clear();
      },
    ));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRoleType.clientRoleBroadcaster) {
      list.add(AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine,
          canvas: const VideoCanvas(uid: 0),
          useFlutterTexture: !Platform.isAndroid,
          useAndroidSurfaceView: Platform.isAndroid,
        ),
        onAgoraVideoViewCreated: (viewId) {
          _engine.startPreview();
        },
      ));
    }
    for (var videoUser in _users) {
      StatefulWidget videoView = AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: videoUser.uid),
          connection: RtcConnection(channelId: widget.channelName),
          useFlutterTexture: !Platform.isAndroid,
          useAndroidSurfaceView: Platform.isAndroid,
        ),
      );
      list.add(videoView);
    }
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();

    if (views.length > 1) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => setState(() => moreThanOne = true));
    }
    if (widget.userCallingType == UserCallingType.receiver &&
        views.length == 1 &&
        moreThanOne) {
      CallingRoomsCubit.get(context)
          .deleteTheRoom(channelId: widget.channelName);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => setState(() => amICalling = false));
      Navigator.of(context).maybePop();
    }

    switch (views.length) {
      case 1:
        return Column(
          children: <Widget>[_videoView(views[0])],
        );
      case 2:
        return Column(
          children: <Widget>[
            video
                ? Expanded(
                    child: Row(
                      children: [_videoView(views[0])],
                    ),
                  )
                : VideoDisabled(),
            _users[0].status
                ? Expanded(
                    child: Row(
                      children: [_videoView(views[1])],
                    ),
                  )
                : VideoDisabled(),
          ],
        );
      case 3:
        return Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  video ? _videoView(views[0]) : VideoDisabled(),
                  _users[0].status ? _videoView(views[1]) : VideoDisabled(),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _users[1].status ? _videoView(views[2]) : VideoDisabled(),
                ],
              ),
            ),
          ],
        );
      case 4:
        return Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  video ? _videoView(views[0]) : VideoDisabled(),
                  _users[0].status ? _videoView(views[1]) : VideoDisabled()
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _users[2].status ? _videoView(views[2]) : VideoDisabled(),
                  _users[3].status ? _videoView(views[3]) : VideoDisabled()
                ],
              ),
            ),
          ],
        );
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar(BuildContext context) {
    if (widget.role == ClientRoleType.clientRoleAudience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 25,
            backgroundColor:
                !muted ? Colors.white : Colors.white.withOpacity(0.2),
            child: IconButton(
              splashColor: Colors.transparent,
              onPressed: _onToggleMute,
              icon: !muted
                  ? const Icon(Icons.mic_off, size: 25, color: Colors.black)
                  : const Icon(
                      Icons.mic,
                      size: 25,
                      color: Colors.white,
                    ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
              radius: 25,
              backgroundColor:
                  !video ? Colors.white : Colors.white.withOpacity(0.2),
              child: IconButton(
                splashColor: Colors.transparent,
                onPressed: _onToggleVideo,
                icon: !video
                    ? const Icon(
                        Icons.videocam_off,
                        color: Colors.black,
                        size: 25,
                      )
                    : const Icon(
                        Icons.videocam,
                        size: 25,
                        color: Colors.white,
                      ),
              )),
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
              radius: 25,
              backgroundColor: Colors.red,
              child: IconButton(
                splashColor: Colors.transparent,
                onPressed: _onCallEnd,
                icon: const Icon(Icons.call_end, size: 25, color: Colors.white),
              )),
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: IconButton(
                  splashColor: Colors.transparent,
                  onPressed: _onSwitchCamera,
                  icon: const Icon(Icons.cameraswitch,
                      size: 25, color: Colors.white))),
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      PIPView.of(context)!.presentBelow(TrainingCategoriesPage());
                    });
                  },
                  icon: const Icon(
                    Icons.picture_in_picture_sharp,
                    size: 25,
                    color: Colors.white,
                  ))),
        ],
      ),
    );
  }

  void _onCallEnd() {
    setState(() => amICalling = false);
    CallingRoomsCubit.get(context).leaveTheRoom(
      userId: myPersonalInfo.userId,
      channelId: widget.channelName,
      isThatAfterJoining: true,
    );
    Navigator.of(context).maybePop();
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(!muted);
  }

  void _onToggleVideo() {
    setState(() {
      video = !video;
      _engine.muteLocalVideoStream(!video);
    });
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    final views = _getRenderViews();
    final numOfUsers = widget.usersInfo?.length;
    return PIPView(builder: (contextwd, isFloating) {
      return Material(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _viewRows(),
              if (views.length == 1) ...[
                Positioned(
                  top: 100,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: _onToggleVideo,
                          child: Icon(
                              video ? Icons.videocam : Icons.videocam_off,
                              color: ColorManager.white,
                              size: 33),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _onToggleMute,
                          child: Icon(
                            muted ? Icons.mic_off : Icons.mic,
                            color: Colors.white,
                            size: 33.0,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _onCallEnd,
                          child: const Icon(Icons.close_rounded,
                              color: ColorManager.white, size: 33),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.usersInfo != null) ...[
                        if (numOfUsers == 1) ...[
                          buildCircleAvatar(0, 1000),
                        ] else if (numOfUsers != 0) ...[
                          Align(
                            alignment: Alignment.bottomRight,
                            child: buildCircleAvatar(0, 700),
                          ),
                          Positioned(
                              height: -15,
                              left: -10,
                              child: buildCircleAvatar(1, 700)),
                        ],
                        const SizedBox(height: 30),
                        ...List.generate(numOfUsers!, (index) {
                          return Text(widget.usersInfo![index].name,
                              style: getNormalStyle(
                                  color: ColorManager.white, fontSize: 25));
                        }),
                      ],
                      const SizedBox(height: 10),
                      Text('Connecting...',
                          style: getNormalStyle(
                              color: ColorManager.white, fontSize: 16.5)),
                    ],
                  ),
                ),
              ] else ...[
                _toolbar(contextwd),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget buildCircleAvatar(int index, double bodyHeight) {
    return Text("");
  }
}

class VideoUser {
  VideoUser(this.uid, this.status);

  int uid = 0;
  bool status = true;
}

class VideoDisabled extends StatefulWidget {
  const VideoDisabled({Key? key}) : super(key: key);

  @override
  State<VideoDisabled> createState() => _VideoDisabledState();
}

class _VideoDisabledState extends State<VideoDisabled> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(child:Container(
        child: Icon(Icons.person,size: 25,)
      )),
    );
  }
}
