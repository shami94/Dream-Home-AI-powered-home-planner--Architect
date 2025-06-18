import 'package:dreamhome_architect/common_widgets.dart/custom_search.dart';
import 'package:dreamhome_architect/features/home_plan/home_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../util/check_login.dart';
import 'home_plan_details.dart';
import 'homeplans_bloc/homeplans_bloc.dart';

class ViewHomeplan extends StatefulWidget {
  const ViewHomeplan({super.key});

  @override
  State<ViewHomeplan> createState() => _ViewHomeplanState();
}

class _ViewHomeplanState extends State<ViewHomeplan> {
  final HomeplansBloc _homeplansBloc = HomeplansBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _homeplans = [];

  @override
  void initState() {
    checkLogin(context);
    getHomeplans();
    super.initState();
  }

  void getHomeplans() {
    _homeplansBloc.add(GetAllHomeplansEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeplansBloc,
      child: BlocConsumer<HomeplansBloc, HomeplansState>(
        listener: (context, state) {
          if (state is HomeplansFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getHomeplans();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is HomeplansGetSuccessState) {
            _homeplans = state.homeplans;
            Logger().w(_homeplans);
            setState(() {});
          } else if (state is HomeplansSuccessState) {
            getHomeplans();
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              if (state is HomeplansLoadingState)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (state is HomeplansGetSuccessState && _homeplans.isEmpty)
                Center(
                  child: Text("No Homeplan found!"),
                ),
              if (state is HomeplansGetSuccessState && _homeplans.isEmpty)
                Center(
                  child: Text("No Homeplan found!"),
                ),
              ListView.separated(
                padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
                itemBuilder: (context, index) => HomePlanCard(
                  cardData: _homeplans[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePlanDetail(
                          homeplanId: _homeplans[index]['id'],
                        ),
                      ),
                    );
                  },
                ),
                separatorBuilder: (context, index) => SizedBox(
                  height: 30,
                ),
                itemCount: _homeplans.length,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: CustomSearch(
                  onSearch: (query) {
                    params['query'] = query;
                    getHomeplans();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
