// import 'package:dreamhome_architect/features/acquired_screen/user_card.dart';
// import 'package:flutter/material.dart';
// import 'package:dreamhome_architect/features/acquired_screen/model.dart';

// class AcquiredScreen extends StatelessWidget {
//   AcquiredScreen({super.key});

//   // Dummy data for home plans
//   final List<HomePlan> homePlans = [
//     HomePlan(
//       name: 'Modern Villa',
//       email: 'RusticCabin@gmail.com',
//       imageUrl: 'https://images6.alphacoders.com/343/thumb-1920-343179.jpg',
//     ),
//     HomePlan(
//       name: 'Cozy Cottage',
//       email: 'RusticCabin@gmail.com',
//       imageUrl:
//           'https://i.pinimg.com/originals/f2/77/0a/f2770a7e835538b9662a47d111e52452.jpg',
//     ),
//     HomePlan(
//       name: 'Modern Villa',
//       email: 'RusticCabin@gmail.com',
//       imageUrl:
//           'https://s3-us-west-1.amazonaws.com/realestatesites.com/stock/slider/beautiful-home1.jpg',
//     ),
//     HomePlan(
//       name: 'Rustic Cabin',
//       email: 'RusticCabin@gmail.com',
//       imageUrl: 'https://images7.alphacoders.com/341/341475.jpg',
//     ),
//     HomePlan(
//       name: 'Urban Loft',
//       email: 'UrbanLoft@gmail.com',
//       imageUrl:
//           'https://i.pinimg.com/originals/0c/c3/c3/0cc3c33133c28423ced7138b976b7d0b.jpg',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//       itemCount: homePlans.length,
//       separatorBuilder: (context, index) => const SizedBox(height: 0),
//       itemBuilder: (context, index) => UserCard(
//         name: homePlans[index].name,
//         email: homePlans[index].email,
//         photoUrl: homePlans[index].imageUrl,
//         onTap: () {},
//       ),
//     );
//   }
// }
