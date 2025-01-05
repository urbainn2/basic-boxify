import 'package:boxify/app_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BundlesForLargeArtist extends StatelessWidget {
  const BundlesForLargeArtist({
    super.key,
    required this.sectionHeight,
    required this.bundles,
    required this.openBundlePreview,
  });

  final double sectionHeight;
  final List<Bundle> bundles;
  final Function openBundlePreview;

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
          const SectionHeader(name: 'Bundles', size: 22),
          SizedBox(
            height: sectionHeight,
            child: GridView.builder(
              controller: ScrollController(),
              itemCount: bundles.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: .75,
              ),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(10),
                child: BundleCardForArtistScreen(
                    bundle: bundles[index],
                    openBundlePreview: openBundlePreview),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class BundlesForSmallArtist extends StatelessWidget {
//   const BundlesForSmallArtist({
//     super.key,
//     required this.bundles,
//     required this.openBundlePreview,
//     required this.admin,
//   });

//   final List<Bundle> bundles;
//   final Function openBundlePreview;
//   final bool admin;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(14.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SectionHeader(name: 'bundles'.translate()),
//           GridView.count(
//             shrinkWrap: true,
//             padding: EdgeInsets.zero,
//             physics: NeverScrollableScrollPhysics(),
//             crossAxisCount: 4,
//             childAspectRatio: 1,
//             children: List.generate(bundles.length, (i) {
//               final bundleImage = bundles[i].image != null
//                   ? bundles[i].image!.replaceAll(
//                         'dl=0',
//                         'raw=1',
//                       )
//                   : Core.app.riversPicUrl;
//               return SmallBundleCardForArtist(
//                   openBundlePreview: openBundlePreview,
//                   bundle: bundles[i],
//                   bundleImage: bundleImage);
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
