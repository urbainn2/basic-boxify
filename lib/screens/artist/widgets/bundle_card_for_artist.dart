// import 'package:app_core/app_core.dart';  //
import 'package:boxify/app_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SmallBundleCardForArtist extends StatelessWidget {
  const SmallBundleCardForArtist({
    super.key,
    required this.openBundlePreview,
    required this.bundle,
    required this.bundleImage,
  });

  final Function openBundlePreview;
  final Bundle bundle;
  final String bundleImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openBundlePreview(bundle),
      child: Card(
        shape: const BeveledRectangleBorder(
          side: BorderSide(
            color: Colors.blueAccent,
            width: .3,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: bundleImage,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Text(
              bundle.title!,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BundleCardForArtistScreen extends StatelessWidget {
  const BundleCardForArtistScreen(
      {super.key, required this.bundle, required this.openBundlePreview});
  final Bundle bundle;
  final Function openBundlePreview;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        openBundlePreview(bundle);
      },
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        color: Colors.black12,
        child: Column(
          children: [
            sizedBox16,
            BundleImage(bundle: bundle),
            sizedBox16,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bundle.title!,
                  style: boldWhite14,
                  overflow: TextOverflow.ellipsis,
                ),
                // Text(
                //   bundle.description!,
                //   overflow: TextOverflow.ellipsis,
                //   // maxLines: 2,
                //   style: TextStyle(
                //     color: Colors.grey,
                //     fontSize: 10,
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
