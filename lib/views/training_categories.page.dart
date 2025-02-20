import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:fc_social_fitness/views/widgets/trainings.widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../utils/flutter_flow.util.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../viewmodels/training_categories.viewmodel.dart';

class TrainingCategoriesPage extends StatefulWidget {
  @override
  _TrainingCategoriesPageState createState() => _TrainingCategoriesPageState();
}

class _TrainingCategoriesPageState extends State<TrainingCategoriesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TrainingCategoriesViewModel>.reactive(
        viewModelBuilder: () => TrainingCategoriesViewModel(context, 2),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return vm.isBusy
              ? FitnessLoading()
              : Scaffold(
                    backgroundColor:
                        FlutterFlowTheme.of(context).secondaryBackground,
                    body: Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: DefaultTabController(
                          length: vm.trainingCategories.length,
                          child: NestedScrollView(
                            headerSliverBuilder: (context, value) {
                              return [
                                SliverAppBar(
                                  leading: Container(),
                                  elevation: 0,
                                  centerTitle: true,
                                  pinned: true,
                                  title: Text(
                                    "Allenamenti",
                                    style: FlutterFlowTheme.of(context).title3,
                                  ),
                                  backgroundColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  expandedHeight: 0,
                                ),
                                SliverPersistentHeader(
                                  pinned: true,
                                  delegate: _SliverAppBarDelegate(
                                      minHeight: 53,
                                      maxHeight: 53,
                                      child: Container(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        child: TabBar(
                                          indicatorColor:
                                              FlutterFlowTheme.of(context)
                                                  .course20,
                                          onTap: (index) {
                                              if(vm.selectedTab != index)
                                                {
                                                  setState(() {
                                                    vm.selectedTab = index;
                                                  });
                                                }
                                              vm.changeGenderTab();
                                          },
                                          labelColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          unselectedLabelColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                          tabs: vm.trainingCategories
                                              .map((trainingCategory) => Text(
                                                    trainingCategory.name!,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1,
                                                  ))
                                              .toList(),
                                        ),
                                      )),
                                ),
                              ];
                            },
                            body: Stack(
                              children: [
                                TabBarView(
                                  physics: NeverScrollableScrollPhysics(),
                                  children: vm.trainingCategories
                                      .map((trainingCategory) =>
                                          TrainingsListWidget(
                                              trainings: vm.trainingsToShow))
                                      .toList(),
                                ),
                                Container(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 25),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 30),
                                            child: Text(
                                                "Filtra allenamento per genere",
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1)),
                                        Container(
                                            height: 40,
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15, top: 5),
                                            child: DropdownButtonFormField2(
                                              dropdownElevation: 1,
                                              buttonDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                              ),
                                              decoration: InputDecoration(

                                                //Add isDense true and zero Padding.
                                                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                //Add more decoration as you want here
                                                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                              ),
                                              isExpanded: true,
                                              hint: Text(
                                                  vm.genderItems[vm
                                                      .selectedGender
                                                      .toString()]!,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1),
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.black45,
                                              ),
                                              iconSize: 30,
                                              buttonHeight: 60,
                                              buttonPadding:
                                                  const EdgeInsets.only(
                                                      left: 20, right: 10),
                                              dropdownDecoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              items: vm.genderItems.entries
                                                  .map((entry) =>
                                                      DropdownMenuItem<String>(
                                                        value: entry.key,
                                                        child: Text(
                                                          entry.value,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1,
                                                        ),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  vm.selectedGender =
                                                      value.toString();
                                                  vm.changeGenderTab();
                                                });
                                              },
                                            ))
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        )),
                  );
        });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
