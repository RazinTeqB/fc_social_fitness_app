import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:fc_social_fitness/viewmodels/base.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/presentation/pages/messages/select_for_group_chat.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/messages_w/list_of_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/functions/toast_show.dart';
import '../../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../../widgets/global/custom_widgets/custom_circulars_progress.dart';

class MessagesPageForMobile extends StatelessWidget {
  const MessagesPageForMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    bool isError = false;
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 90),
        child: WillPopScope(
            onWillPop: () async => true,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              floatingActionButton: FloatingActionButton(
                elevation: 2,
                heroTag: "createChat",
                onPressed: () {
                  pushToPage(context, page: const SelectForGroupChat());
                },
                backgroundColor: FlutterFlowTheme.of(context).course20,
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              body: StreamBuilder<int>(
                stream: CustomBaseViewModel.numberOfMessage,
                builder: (context, snapshot) {
                  return BlocListener<UserInfoCubit, UserInfoState>(
                    bloc: UserInfoCubit.get(context)
                      ..getUserInfo(myPersonalId, isThatMyPersonalId: true),
                    listener: (context, state) {
                      if (state is CubitMyPersonalInfoLoaded) {
                        isLoading = false;
                        isError = false;
                      } else if (state is CubitGetUserInfoFailed) {
                        isLoading = false;
                        isError = true;
                        ToastShow.toastStateError(state);
                      } else {
                        isLoading = true;
                        isError = false;
                      }
                    },
                    child: isLoading
                        ? const ThineCircularProgress()
                        : isError
                            ? const Text("Error")
                            : ListOfMessages(
                                myPersonalInfo:
                                    UserInfoCubit.getMyPersonalInfo(context),
                              ),
                  );
                },
              ),
            )));
  }
}
