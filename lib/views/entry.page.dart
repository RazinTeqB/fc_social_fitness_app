import 'package:fc_social_fitness/views/home.page.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacked/stacked.dart';
import '../social/config/routes/app_routes.dart';
import '../social/core/utility/constant.dart';
import '../social/presentation/cubit/firestoreUserInfoCubit/users_info_reel_time/users_info_reel_time_bloc.dart';
import '../social/presentation/pages/messages/ringing_page.dart';
import '../viewmodels/entry.viewmodel.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({Key? key, required this.startPage}) : super(key: key);
  final Widget startPage;
  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  bool isHeMoved = false;

  @override
  void initState() {
    super.initState();
  }


  Widget build(BuildContext context) {
    return ViewModelBuilder<EntryViewModel>.reactive(
        viewModelBuilder: () => EntryViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return vm.isBusy ?
          FitnessLoading() :
          BlocBuilder<UsersInfoReelTimeBloc, UsersInfoReelTimeState>(
            bloc: UsersInfoReelTimeBloc.get(context)
              ..add(LoadMyPersonalInfo()),
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (state is MyPersonalInfoLoaded &&
                    !amICalling &&
                    state.myPersonalInfoInReelTime.channelId.isNotEmpty) {
                  if (!isHeMoved) {
                    isHeMoved = true;
                    pushToPage(context,
                        page: CallingRingingPage(
                            channelId: state.myPersonalInfoInReelTime.channelId,
                            clearMoving: clearMoving),
                        withoutRoot: false);
                  }
                }
              });
                return widget.startPage;
            },
          );
        });}

    clearMoving() {
      isHeMoved = false;
    }
  }
