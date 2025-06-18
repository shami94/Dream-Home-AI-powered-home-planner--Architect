import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../common_widgets.dart/custom_button.dart';
import '../../common_widgets.dart/custom_image_picker_button.dart';
import '../../common_widgets.dart/custom_text_formfield.dart';
import '../../util/value_validator.dart';
import 'floors_bloc/floors_bloc.dart';

class AddEditFloorScreen extends StatefulWidget {
  final Map? floorDetails;
  final int homeplanID;
  const AddEditFloorScreen(
      {super.key, this.floorDetails, required this.homeplanID});

  @override
  State<AddEditFloorScreen> createState() => _AddEditFloorScreenState();
}

class _AddEditFloorScreenState extends State<AddEditFloorScreen> {
  final TextEditingController _floorNameController = TextEditingController();
  final TextEditingController _floorDesController = TextEditingController();
  final TextEditingController _bedroomController = TextEditingController();
  final TextEditingController _bathroomController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? coverImage;

  @override
  void initState() {
    if (widget.floorDetails != null) {
      _floorNameController.text = widget.floorDetails!['name'];
      _floorDesController.text = widget.floorDetails!['description'];
      _bedroomController.text = widget.floorDetails!['bedrooms'].toString();
      _bathroomController.text = widget.floorDetails!['bathrooms'].toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FloorsBloc(),
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
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is FloorsSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  CustomImagePickerButton(
                    selectedImage: widget.floorDetails?['image_url'],
                    height: 200,
                    width: 400,
                    onPick: (file) {
                      coverImage = file;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Floor Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    isLoading: state is FloorsLoadingState,
                    labelText: 'Floor Name',
                    controller: _floorNameController,
                    validator: alphabeticWithSpaceValidator,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bedrooms',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    isLoading: state is FloorsLoadingState,
                    labelText: 'Bedrooms',
                    controller: _bedroomController,
                    validator: numericValidator,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Bathrooms',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    isLoading: state is FloorsLoadingState,
                    labelText: 'Bathrooms',
                    controller: _bathroomController,
                    validator: numericValidator,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    minLines: 3,
                    maxLines: 3,
                    isLoading: state is FloorsLoadingState,
                    labelText: 'Description',
                    controller: _floorDesController,
                    validator: notEmptyValidator,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                isLoading: state is FloorsLoadingState,
                inverse: true,
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      ((coverImage != null) || widget.floorDetails != null)) {
                    Map<String, dynamic> details = {
                      'name': _floorNameController.text.trim(),
                      'description': _floorDesController.text.trim(),
                      'bedrooms': _bedroomController.text.trim(),
                      'bathrooms': _bathroomController.text.trim(),
                      'homeplan_id': widget.homeplanID,
                    };

                    if (coverImage != null) {
                      details['image'] = coverImage!;
                      details['image_name'] = coverImage!.path;
                    }

                    if (widget.floorDetails != null) {
                      BlocProvider.of<FloorsBloc>(context).add(
                        EditFloorEvent(
                          floorId: widget.floorDetails!['id'],
                          floorDetails: details,
                        ),
                      );
                    } else {
                      BlocProvider.of<FloorsBloc>(context).add(
                        AddFloorEvent(
                          floorDetails: details,
                        ),
                      );
                    }
                  }
                },
                label: "Next",
              ),
            ),
          );
        },
      ),
    );
  }
}
