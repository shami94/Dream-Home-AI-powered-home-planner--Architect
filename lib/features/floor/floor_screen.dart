import 'package:dreamhome_architect/common_widgets.dart/custom_button.dart';
import 'package:dreamhome_architect/features/floor/add_edit_floor_screen.dart';
import 'package:dreamhome_architect/features/floor/floor_card.dart';
import 'package:dreamhome_architect/features/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../util/check_login.dart';
import 'floors_bloc/floors_bloc.dart';

class FloorScreen extends StatefulWidget {
  final int homeplanID;
  const FloorScreen({super.key, required this.homeplanID});

  @override
  State<FloorScreen> createState() => _FloorScreenState();
}

class _FloorScreenState extends State<FloorScreen> {
  final FloorsBloc _floorsBloc = FloorsBloc();

  Map<String, dynamic> params = {
    'query': null,
    'id': null,
  };

  List<Map> _floors = [];

  @override
  void initState() {
    params['id'] = widget.homeplanID;
    checkLogin(context);
    getFloors();
    super.initState();
  }

  void getFloors() {
    _floorsBloc.add(GetAllFloorsEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          CustomButton(
            inverse: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditFloorScreen(
                    homeplanID: widget.homeplanID,
                  ),
                ),
              ).then((value) => getFloors());
            },
            label: 'Add Floor',
            iconData: Icons.add,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _floorsBloc,
        child: BlocConsumer<FloorsBloc, FloorsState>(
          listener: (context, state) {
            if (state is FloorsFailureState) {
              showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                  title: 'Failure',
                  description: state.message,
                  primaryButton: 'Try Again',
                  onPrimaryPressed: () {
                    getFloors();
                    Navigator.pop(context);
                  },
                ),
              );
            } else if (state is FloorsGetSuccessState) {
              _floors = state.floors;
              Logger().w(_floors);
              setState(() {});
            } else if (state is FloorsSuccessState) {
              getFloors();
            }
          },
          builder: (context, state) {
            if (state is FloorsLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is FloorsGetSuccessState && _floors.isEmpty) {
              return Center(
                child: Text("No Floor found!"),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) => FloorCard(
                cardData: _floors[index],
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditFloorScreen(
                        floorDetails: _floors[index],
                        homeplanID: widget.homeplanID,
                      ),
                    ),
                  ).then((value) => getFloors());
                },
                onDelete: () {
                  showDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog(
                      title: 'Delete Floor?',
                      description:
                          'Are you sure you want to delete this floor? This action cannot be undone.',
                      primaryButton: 'Delete',
                      onPrimaryPressed: () {
                        _floorsBloc.add(
                          DeleteFloorEvent(
                            floorId: _floors[index]['id'],
                          ),
                        );
                        Navigator.pop(context);
                      },
                      secondaryButton: 'Cancel',
                    ),
                  );
                },
              ),
              separatorBuilder: (context, index) => SizedBox(
                height: 30,
              ),
              itemCount: _floors.length,
            );
          },
        ),
      ),
    );
  }
}
