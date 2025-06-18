// import 'package:dreamhome_architect/theme/app_theme.dart';
// import 'package:flutter/material.dart';

// class UserCard extends StatelessWidget {
//   final String? photoUrl;
//   final String name;
//   final String email;
//   final Function() onTap;

//   const UserCard({
//     super.key,
//     this.photoUrl,
//     required this.name,
//     required this.email,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(64),
//         side: BorderSide(
//           color: outlineColor,
//           width: 3,
//         ),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(64),
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Row(
//             children: [
//               // User Photo
//               CircleAvatar(
//                 radius: 32,
//                 backgroundColor: Colors.grey[200],
//                 backgroundImage:
//                     photoUrl != null ? NetworkImage(photoUrl!) : null,
//                 child: photoUrl == null
//                     ? const Icon(
//                         Icons.person,
//                         size: 32,
//                         color: Colors.grey,
//                       )
//                     : null,
//               ),
//               const SizedBox(width: 16),
//               // User Info
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       email,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Optional trailing icon
//               const Icon(
//                 Icons.chevron_right,
//                 color: Colors.grey,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
