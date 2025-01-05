import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String name;
  final double size;

  const SectionHeader({super.key, required this.name, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    final screenType = Utils.getScreenType(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        name,
        style: TextStyle(
          fontSize: size * screenType,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// The headers for the sections on the home screen, like "Best Of"
// class SectionHeader extends StatelessWidget {
//   const SectionHeader({Key? key, required this.sectionName}) : super(key: key);

//   final String sectionName;

//   @override
//   Widget build(BuildContext context) {
//     final screenType = Utils.getScreenType(context);
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: 20.0 * screenType,
//         vertical: 20.0 * screenType,
//       ),
//       child: Text(
//         sectionName,
//         style: TextStyle(
//           fontSize: 25.0 * screenType,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

// /// Could be consolidated, no?
// class ArtistSectionHeader extends StatelessWidget {
//   const ArtistSectionHeader({
//     Key? key,
//     required this.name,
//   }) : super(
//           key: key,
//         );
//   final String name;
//   @override
//   Widget build(BuildContext context) {
//     final screenType = Utils.getScreenType(context);
//     return Padding(
//         padding: const EdgeInsets.all(8),
//         // child: Text(name, style: boldWhite18),
//         child: Text(
//           name,
//           style: TextStyle(
//             fontSize: 18.0 * screenType,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ));
//   }
// }

// class LargeSectionHeader extends StatelessWidget {
//   const LargeSectionHeader({
//     Key? key,
//     required this.name,
//   }) : super(key: key);

//   final String name;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: Text(name, style: boldWhite22),
//     );
//   }
// }
