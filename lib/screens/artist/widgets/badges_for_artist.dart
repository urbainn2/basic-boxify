import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

// class BadgesForSmallArtist extends StatelessWidget {
//   const BadgesForSmallArtist({
//     super.key,
//     required this.badges,
//     required this.openBadgePreview,
//   });

//   final List<MyBadge> badges;
//   final Function openBadgePreview;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SectionHeader(name: 'badges'.translate()),
//           GridView.count(
//             shrinkWrap: true,
//             padding: EdgeInsets.zero,
//             physics: NeverScrollableScrollPhysics(),
//             crossAxisCount: 4,
//             childAspectRatio: 1,
//             children: List.generate(badges.length, (i) {
//               final badge = badges[i];
//               return SmallBadgeCard(
//                   openBadgePreview: openBadgePreview, badge: badge);
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

class BadgesForLargeArtist extends StatelessWidget {
  const BadgesForLargeArtist({
    super.key,
    required this.sectionHeight,
    required this.badges,
    required this.openBadgePreview,
  });

  final double sectionHeight;
  final List<MyBadge> badges;

  final openBadgePreview;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width

    int crossAxisCount = screenWidth ~/
        250; // This will divide the screenWidth by 200 and return an integer value. Change this value to increase or decrease the count.

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(name: 'badges'.translate()),
          SizedBox(
            height: sectionHeight,
            child: GridView.builder(
              controller: ScrollController(), //just add this line
              itemCount: badges.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: .75,
              ),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    // _goToBadge(context, index);
                    openBadgePreview(badges[index]);
                  },
                  child: LargeBadgeCard(badge: badges[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
