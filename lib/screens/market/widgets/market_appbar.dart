import 'package:boxify/app_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MarketAppBar extends PreferredSize {
  const MarketAppBar({super.key, required this.profileImageUrl})
      : super(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: const SizedBox.shrink(),
        );
  final String profileImageUrl;

  // @override
  // Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // MediaQueryData device;
    // device = MediaQuery.of(context);
    return AppBar(
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1.0),
      leading: CachedNetworkImage(
        // height: 25.0,
        // width: 25.0,
        imageUrl: profileImageUrl,
        imageBuilder: (context, imageProvider) => Container(
          // width: 20.0,
          // height: 20.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        // placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        // fit:
      ),

      // title: material.Image.asset('assets/images/mrn.png', height: Core.app.smallRowImageSize.0),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'market'.translate(),
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
