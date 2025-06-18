import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../util/format_function.dart';
import '../floor/add_edit_floor_screen.dart';
import 'add_edit_homeplan.dart';
import 'feature_card.dart';
import 'homeplans_bloc/homeplans_bloc.dart';

class HomePlanDetail extends StatefulWidget {
  final int homeplanId;
  const HomePlanDetail({
    super.key,
    required this.homeplanId,
  }); // Constructor with required parameter

  @override
  State<HomePlanDetail> createState() => _HomePlanDetailState();
}

class _HomePlanDetailState extends State<HomePlanDetail> {
  final HomeplansBloc _homeplansBloc = HomeplansBloc();

  Map<String, dynamic> _homeplan = {};
  List _floors = [];

  @override
  void initState() {
    getHomeplans();
    super.initState();
  }

  void getHomeplans() {
    _homeplansBloc.add(GetAllHomeplanByIdEvent(homeplanID: widget.homeplanId));
  }

  int getTotalBedrooms(List? properties) {
    if (properties == null || properties.isEmpty) {
      return 0; // Return 0 if the list is null or empty
    }

    return properties.fold(0, (sum, property) {
      int bedrooms =
          property['bedrooms'] ?? 0; // Default to 0 if 'bedrooms' is missing
      return sum + bedrooms;
    });
  }

  int getTotalBathroom(List? properties) {
    if (properties == null || properties.isEmpty) {
      return 0; // Return 0 if the list is null or empty
    }

    return properties.fold(0, (sum, property) {
      int bedrooms =
          property['bathrooms'] ?? 0; // Default to 0 if 'bedrooms' is missing
      return sum + bedrooms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider.value(
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
            } else if (state is HomeplansGetByIdSuccessState) {
              _homeplan = state.homeplan;
              _floors = _homeplan['floors'];
              Logger().w(_homeplan);
              setState(() {});
            } else if (state is HomeplansSuccessState) {
              getHomeplans();
            }
          },
          builder: (context, state) {
            if (state is HomeplansLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is HomeplansGetSuccessState && _homeplan.isEmpty) {
              return Center(
                child: Text("No Homeplan found!"),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      if (_homeplan['image_url'] != null)
                        Image.network(
                          _homeplan['image_url'],
                          fit: BoxFit.cover,
                          height: 400,
                          width: double.infinity,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 40),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: CircleAvatar(
                                radius: 15,
                                child: Icon(Icons.chevron_left),
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddEditHomeplan(
                                      homeplanDetails: _homeplan,
                                    ),
                                  ),
                                ).then((value) {
                                  getHomeplans();
                                });
                              },
                              child: Text(
                                'Edit',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatValue(_homeplan['name']),
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            FeatureCard(
                              text: "${getTotalBedrooms(_floors)} Bed",
                              icon: Icons.bed,
                            ),
                            FeatureCard(
                              icon: Icons.bathtub,
                              text: "${getTotalBathroom(_floors)} Bath",
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Plot Details',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            FeatureCard(
                              icon: Icons.straighten, // represents length
                              text:
                                  "${formatValue(_homeplan['plot_length'])} m Length",
                            ),
                            FeatureCard(
                              icon: Icons.straighten, // can use same for width
                              text:
                                  "${formatValue(_homeplan['plot_width'])} m Width",
                            ),
                            FeatureCard(
                              icon: Icons.square_foot,
                              text:
                                  "${formatValue(_homeplan['plot_area'])} m² Area",
                            ),
                            FeatureCard(
                              icon: Icons.directions, // road facing
                              text:
                                  "${formatValue(_homeplan['road_facing'])} Facing",
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Description',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          formatValue(_homeplan['description']),
                          style: TextStyle(fontSize: 14.0),
                        ),
                        const SizedBox(height: 20),
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 100),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => FloorCard(
                            floorDetails: _floors[index],
                            onDeleted: () {
                              showDialog(
                                context: context,
                                builder: (context) => CustomAlertDialog(
                                  title: 'Delete Floor?',
                                  description:
                                      'Deletion will fail if there are records under this Floor',
                                  primaryButton: 'Delete',
                                  onPrimaryPressed: () {
                                    _homeplansBloc.add(
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹${formatInteger(_homeplan['price'])}',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddEditFloorScreen(homeplanID: _homeplan['id']),
            ),
          ).then((value) {
            getHomeplans();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class FloorCard extends StatelessWidget {
  final Map<String, dynamic> floorDetails;
  final Function() onDeleted;

  const FloorCard({
    super.key,
    required this.floorDetails,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                formatValue(floorDetails['name']).toUpperCase(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDeleted,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: [
            FeatureCard(
              text: "${formatValue(floorDetails['bedrooms'])} Bed",
              icon: Icons.bed,
            ),
            FeatureCard(
              icon: Icons.bathtub,
              text: "${formatValue(floorDetails['bathrooms'])} Bath",
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          formatValue(floorDetails['description']),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 10),
        Text(
          'Image',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (floorDetails['image_url'] != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              floorDetails['image_url'],
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}
