import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'in_view_state.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/time_line_w/smart_refresher.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:stream_transform/stream_transform.dart';

import 'widget_data.dart';

class InViewNotifier extends StatefulWidget {
  ///The String list of ids of the child widgets that should be initialized as inView
  ///when the list view is built for the first time.
  final List<String> initialInViewIds;

  ///The widget that should be displayed in the [InViewNotifier].
  final ScrollView child;

  ///The distance from the bottom of the list where the [onListEndReached] should be invoked.
  final double endNotificationOffset;

  ///The function that is invoked when the list scroll reaches the end
  ///or the [endNotificationOffset] if provided.
  final VoidCallback? onListEndReached;

  ///The duration to be used for throttling the scroll notification.
  ///Defaults to 200 milliseconds.
  final Duration throttleDuration;

  ///The axis along which the scroll view scrolls.
  final Axis scrollDirection;

  ///The function that defines the area within which the widgets should be notified
  ///as inView.
  final IsInViewPortCondition isInViewPortCondition;
  final List postsIds;
  final ValueNotifier<bool> isThatEndOfList;
  final AsyncValueSetter<int> onRefreshData;
  InViewNotifier({
    Key? key,
    required this.child,
    required this.onRefreshData,
    required this.isThatEndOfList,
    required this.postsIds,
    this.initialInViewIds = const [],
    this.endNotificationOffset = 0.0,
    this.onListEndReached,
    this.throttleDuration = const Duration(milliseconds: 200),
    required this.isInViewPortCondition,
  })  : assert(endNotificationOffset >= 0.0),
        scrollDirection = child.scrollDirection,
        super(key: key);

  @override
  InViewNotifierState createState() => InViewNotifierState();
}

class InViewNotifierState extends State<InViewNotifier> {
  InViewState? _inViewState;
  StreamController<ScrollNotification>? _streamController;

  @override
  void initState() {
    super.initState();
    _initializeInViewState();
    _startListening();
  }

  @override
  void didUpdateWidget(InViewNotifier oldWidget) {
    if (oldWidget.throttleDuration != widget.throttleDuration) {
      //when throttle duration changes, close the existing stream controller if exists
      //and start listening to a stream that is throttled by new duration.
      _streamController?.close();
      _startListening();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _inViewState?.dispose();
    _inViewState = null;
    _streamController?.close();
    super.dispose();
  }

  void _startListening() {
    _streamController = StreamController<ScrollNotification>();

    _streamController!.stream
        .audit(widget.throttleDuration)
        .listen(_inViewState!.onScroll);
  }

  void _initializeInViewState() {
    _inViewState = InViewState(
      initialIds: widget.initialInViewIds,
      isInViewCondition: widget.isInViewPortCondition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InheritedInViewWidget(
      inViewState: _inViewState,
      child: NotificationListener<ScrollNotification>(
        child: SmarterRefresh(
          onRefreshData: widget.onRefreshData,
          posts: widget.postsIds,
          isThatEndOfList: widget.isThatEndOfList,
          child: widget.child,
        ),
        onNotification: (ScrollNotification notification) {
          late bool isScrollDirection;
          final AxisDirection scrollDirection =
              notification.metrics.axisDirection;

          switch (widget.scrollDirection) {
            case Axis.vertical:
              isScrollDirection = scrollDirection == AxisDirection.down ||
                  scrollDirection == AxisDirection.up;
              break;
            case Axis.horizontal:
              isScrollDirection = scrollDirection == AxisDirection.left ||
                  scrollDirection == AxisDirection.right;
              break;
          }
          final double maxScroll = notification.metrics.maxScrollExtent;

          //end of the listview reached
          if (isScrollDirection &&
              maxScroll - notification.metrics.pixels <=
                  widget.endNotificationOffset) {
            if (widget.onListEndReached != null) {
              widget.onListEndReached!();
            }
          }

          //when user is not scrolling
          if (notification is UserScrollNotification &&
              notification.direction == ScrollDirection.idle) {
            if (!_streamController!.isClosed && isScrollDirection) {
              _streamController!.add(notification);
            }
          }

          if (!_streamController!.isClosed && isScrollDirection) {
            _streamController!.add(notification);
          }
          return false;
        },
      ),
    );
  }
}

typedef IsInViewPortCondition = bool Function(
  double deltaTop,
  double deltaBottom,
  double viewPortDimension,
);
