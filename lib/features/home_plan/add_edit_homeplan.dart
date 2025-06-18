import 'dart:io';

import 'package:dreamhome_architect/common_widgets.dart/custom_button.dart';
import 'package:dreamhome_architect/common_widgets.dart/custom_dropdownmenu.dart';
import 'package:dreamhome_architect/common_widgets.dart/custom_image_picker_button.dart';
import 'package:dreamhome_architect/common_widgets.dart/custom_text_formfield.dart';
import 'package:dreamhome_architect/features/floor/floor_screen.dart';
import 'package:dreamhome_architect/features/home_plan/homeplans_bloc/homeplans_bloc.dart';
import 'package:dreamhome_architect/util/value_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';

class AddEditHomeplan extends StatefulWidget {
  final Map<String, dynamic>? homeplanDetails;
  final int? categoryId;
  const AddEditHomeplan({super.key, this.homeplanDetails, this.categoryId});

  @override
  State<AddEditHomeplan> createState() => _AddEditHomeplanState();
}

class _AddEditHomeplanState extends State<AddEditHomeplan> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _plotLengthController = TextEditingController();
  final TextEditingController _plotWidthController = TextEditingController();
  final TextEditingController _plotAreaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final HomeplansBloc _homeplansBloc = HomeplansBloc();

  File? coverImage;
  List _categories = [];
  int? _selectedCategory;
  String _selectedRoadFacing = 'North';
  final List roadFacingOptions = [
    {'name': 'North'},
    {'name': 'South'},
    {'name': 'East'},
    {'name': 'West'},
    {'name': 'Northeast'},
    {'name': 'Northwest'},
    {'name': 'Southeast'},
    {'name': 'Southwest'},
  ];

  void calculatePlotArea() {
    final int? length = int.tryParse(_plotLengthController.text.trim());
    final int? width = int.tryParse(_plotWidthController.text.trim());

    if (length != null && width != null) {
      final int area = length * width;
      _plotAreaController.text = area.toString(); // sets area to controller
    } else {
      _plotAreaController.text = ''; // clear if input is invalid
    }
  }

  @override
  void initState() {
    getCategories();
    if (widget.homeplanDetails != null &&
        widget.homeplanDetails!['category'] != null) {
      _titleController.text = widget.homeplanDetails!['name'];
      _desController.text = widget.homeplanDetails!['description'];
      _priceController.text = widget.homeplanDetails!['price'].toString();
      _selectedCategory = widget.homeplanDetails!['category_id'];
      _plotAreaController.text = widget.homeplanDetails!['plot_area'];
      _plotLengthController.text = widget.homeplanDetails!['plot_length'];
      _plotWidthController.text = widget.homeplanDetails!['plot_width'];
    }
    if (widget.categoryId != null) {
      _selectedCategory = widget.categoryId;
    }
    super.initState();
  }

  void getCategories() {
    _homeplansBloc.add(GetAllCategoriesEvent());
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
                  getCategories();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is CategoriesGetSuccessState) {
            _categories = state.categories;
            Logger().w(_categories);
          } else if (state is AddHomeplanSuccessState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FloorScreen(
                        homeplanID: state.homeplanID,
                      )),
            );
          } else if (state is HomeplansSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(
                    'Add homeplan image',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomImagePickerButton(
                    selectedImage: widget.homeplanDetails?['image_url'],
                    height: 200,
                    width: 400,
                    onPick: (file) {
                      coverImage = file;
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Title',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    isLoading: state is HomeplansLoadingState,
                    labelText: 'Enter Title',
                    controller: _titleController,
                    validator: alphabeticWithSpaceValidator,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Plot Length (m)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    isLoading: state is HomeplansLoadingState,
                    labelText: 'Enter Length',
                    controller: _plotLengthController,
                    validator: numericValidator,
                    onChanged: (value) {
                      calculatePlotArea();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Plot Width (m)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    isLoading: state is HomeplansLoadingState,
                    labelText: 'Enter Width',
                    controller: _plotWidthController,
                    validator: numericValidator,
                    onChanged: (value) {
                      calculatePlotArea();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Plot Area (m²)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    isLoading: state is HomeplansLoadingState,
                    labelText: 'Enter Area',
                    controller: _plotAreaController,
                    validator: numericValidator,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomDropDownMenu(
                    iconData: Icons.explore,
                    isExpanded: true,
                    isRequired: true,
                    selectedValue: _selectedRoadFacing,
                    title: 'Road Facing',
                    hintText: "Select Road Facing",
                    onSelected: (selected) {
                      _selectedRoadFacing = selected;
                    },
                    dropdownMenuItems: List.generate(
                      roadFacingOptions.length,
                      (index) => DropdownMenuItem(
                        value: roadFacingOptions[index]['name'],
                        child: Text(roadFacingOptions[index]['name']),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomDropDownMenu(
                    iconData: Icons.category,
                    isExpanded: true,
                    isRequired: true,
                    selectedValue: _selectedCategory,
                    title: 'Category',
                    hintText: "Select Category",
                    onSelected: (selected) {
                      _selectedCategory = selected;
                    },
                    dropdownMenuItems: List.generate(
                      _categories.length,
                      (index) => DropdownMenuItem(
                        value: _categories[index]['id'],
                        child: Text(_categories[index]['name']),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Price',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    isLoading: state is HomeplansLoadingState,
                    labelText: 'Enter Price',
                    controller: _priceController,
                    validator: numericValidator,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    minLines: 3,
                    maxLines: 3,
                    isLoading: state is HomeplansLoadingState,
                    labelText: 'Enter Description',
                    controller: _desController,
                    validator: notEmptyValidator,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                isLoading: state is HomeplansLoadingState,
                inverse: true,
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      ((coverImage != null) ||
                          widget.homeplanDetails != null)) {
                    Map<String, dynamic> details = {
                      'name': _titleController.text.trim(),
                      'description': _desController.text.trim(),
                      'price': _priceController.text.trim(),
                      'category_id': _selectedCategory,
                      'road_facing': _selectedRoadFacing,
                      'plot_length': _plotLengthController.text.trim(),
                      'plot_width': _plotWidthController.text.trim(),
                      'plot_area': _plotAreaController.text.trim(),
                    };

                    if (coverImage != null) {
                      details['image'] = coverImage;
                      details['image_name'] = coverImage!.path;
                    }

                    if (widget.homeplanDetails != null) {
                      BlocProvider.of<HomeplansBloc>(context).add(
                        EditHomeplanEvent(
                          homeplanId: widget.homeplanDetails!['id'],
                          homeplanDetails: details,
                        ),
                      );
                    } else {
                      BlocProvider.of<HomeplansBloc>(context).add(
                        AddHomeplanEvent(
                          homeplanDetails: details,
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
