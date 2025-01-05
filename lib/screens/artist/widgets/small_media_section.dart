import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

class SmallSection extends StatelessWidget {
  const SmallSection({
    super.key,
    required this.name,
    required this.child,
    this.onTap,
  });

  final String name;
  final Function? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(name: name.translate()),
          child,
        ],
      ),
    );
  }
}

class SmallMediaSection extends StatelessWidget {
  const SmallMediaSection({
    super.key,
    required this.mediaItems,
    required this.name,
    this.onTap,
  });

  final List<dynamic> mediaItems;
  final String name;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return SmallSection(
      name: name,
      child: GridView.count(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 4,
          childAspectRatio: 1,
          children: List.generate(mediaItems.length, (index) {
            final item = mediaItems[index];
            if (item is Playlist) {
              return SmallPlaylistCard(playlist: item);
            } else if (item is Bundle) {
              return SmallBundleCardForArtist(
                  openBundlePreview: onTap!,
                  bundle: item,
                  bundleImage: item.image != null
                      ? item.image!.replaceAll(
                          'dl=0',
                          'raw=1',
                        )
                      : Core.app.riversPicUrl);
            } else if (item is MyBadge) {
              return SmallBadgeCard(openBadgePreview: onTap!, badge: item);
            }

            return Container();
          })),
    );
  }
}
