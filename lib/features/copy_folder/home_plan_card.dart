// import 'package:flutter/material.dart';
// import '../../theme/app_theme.dart';
// import '../../util/format_function.dart';

// class HomePlanCard extends StatelessWidget {
//   final Function() onTap;
//   final Map cardData;
//   const HomePlanCard({
//     super.key,
//     required this.cardData,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       elevation: 4,
//       shadowColor: shadowColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Stack(
//           children: [
//             if (cardData['image_url'] != null)
//               ClipRRect(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                 child: Image.network(
//                   cardData['image_url'],
//                   fit: BoxFit.cover,
//                   height: 220,
//                   width: double.infinity,
//                 ),
//               ),
//             Padding(
//               padding: const EdgeInsets.only(top: 207),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Material(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Padding(
//                     padding: EdgeInsets.all(14),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           formatValue(cardData['name']),
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           formatValue(cardData['description']),
//                           style: TextStyle(fontSize: 14, color: Colors.grey),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           '₹${formatValue(cardData['price'])}',
//                           style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.green),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//     //  ListTile(
//     //                   leading: CircleAvatar(
//     //                     backgroundImage: NetworkImage(
//     //                         'https://randomuser.me/api/portraits/men/1.jpg'),
//     //                   ),
//     //                   title: Text("Architect Name"),
//     //                   subtitle: Text("Professional Architect"),
//     //                 ),
