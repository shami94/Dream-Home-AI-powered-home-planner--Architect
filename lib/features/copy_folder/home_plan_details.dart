// import 'package:dreamhome_architect/features/floor/add_edit_floor_screen.dart';
// import 'package:dreamhome_architect/features/home_plan/add_edit_homeplan.dart';
// import 'package:flutter/material.dart';

// import '../../util/format_function.dart';
// import 'feature_card.dart';

// class HomePlanDetail extends StatefulWidget {
//   final Map homeplan;
//   const HomePlanDetail({
//     super.key,
//     required this.homeplan,
//   }); // Constructor with required parameter

//   @override
//   State<HomePlanDetail> createState() => _HomePlanDetailState();
// }

// class _HomePlanDetailState extends State<HomePlanDetail> {
//   late Map _homeplan;
//   late List _floors;

//   @override
//   void initState() {
//     _homeplan = widget.homeplan;
//     _floors = _homeplan['floor_plans'] ?? [];
//     super.initState();
//   }

//   int getTotalBedrooms(List? properties) {
//     if (properties == null || properties.isEmpty) {
//       return 0; // Return 0 if the list is null or empty
//     }

//     return properties.fold(0, (sum, property) {
//       int bedrooms =
//           property['bedrooms'] ?? 0; // Default to 0 if 'bedrooms' is missing
//       return sum + bedrooms;
//     });
//   }

//   int getTotalBathroom(List? properties) {
//     if (properties == null || properties.isEmpty) {
//       return 0; // Return 0 if the list is null or empty
//     }

//     return properties.fold(0, (sum, property) {
//       int bedrooms =
//           property['bathrooms'] ?? 0; // Default to 0 if 'bedrooms' is missing
//       return sum + bedrooms;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 if (_homeplan['image_url'] != null)
//                   Image.network(
//                     _homeplan['image_url'],
//                     fit: BoxFit.cover,
//                     height: 400,
//                     width: double.infinity,
//                   ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, top: 40),
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: CircleAvatar(
//                           radius: 15,
//                           child: Icon(Icons.chevron_left),
//                         ),
//                       ),
//                       Spacer(),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   AddEditHomeplan(homeplanDetails: _homeplan),
//                             ),
//                           );
//                         },
//                         child: Text(
//                           'Edit',
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyLarge!
//                               .copyWith(color: Colors.white),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     formatValue(_homeplan['name']),
//                     style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 5),
//                   Wrap(
//                     runSpacing: 10,
//                     spacing: 10,
//                     children: [
//                       FeatureCard(
//                         text: "${getTotalBedrooms(_floors)} Bed",
//                         icon: Icons.bed,
//                       ),
//                       FeatureCard(
//                         icon: Icons.bathtub,
//                         text: "${getTotalBathroom(_floors)} Bath",
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Description',
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     formatValue(_homeplan['description']),
//                     style: TextStyle(fontSize: 14.0),
//                   ),
//                   const SizedBox(height: 20),
//                   ListView.separated(
//                     physics: NeverScrollableScrollPhysics(),
//                     padding: EdgeInsets.only(bottom: 100),
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) => FloorCard(
//                       floorDetails: _floors[index],
//                     ),
//                     separatorBuilder: (context, index) => SizedBox(
//                       height: 30,
//                     ),
//                     itemCount: _floors.length,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   AddEditFloorScreen(homeplanID: _homeplan['id']),
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

// class FloorCard extends StatelessWidget {
//   final Map<String, dynamic> floorDetails;
//   const FloorCard({
//     super.key,
//     required this.floorDetails,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           formatValue(floorDetails['name']).toUpperCase(),
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         Wrap(
//           runSpacing: 10,
//           spacing: 10,
//           children: [
//             FeatureCard(
//               text: "${formatValue(floorDetails['bedrooms'])} Bed",
//               icon: Icons.bed,
//             ),
//             FeatureCard(
//               icon: Icons.bathtub,
//               text: "${formatValue(floorDetails['bathrooms'])} Bath",
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Text(
//           formatValue(floorDetails['description']),
//           style: Theme.of(context).textTheme.bodyLarge,
//         ),
//         const SizedBox(height: 10),
//         Text(
//           'Image',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         if (floorDetails['image_url'] != null)
//           ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Image.network(
//               floorDetails['image_url'],
//               fit: BoxFit.cover,
//             ),
//           ),
//       ],
//     );
//   }
// }
