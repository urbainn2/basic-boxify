import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlaylistsForLargeArtist extends StatelessWidget {
  const PlaylistsForLargeArtist({
    super.key,
    required this.sectionHeight,
    required this.playlists,
  });

  final double sectionHeight;
  final List<Playlist> playlists;

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
          const SectionHeader(name: 'Playlists', size: 22),
          SizedBox(
            height: sectionHeight,
            child: GridView.builder(
              shrinkWrap: true,
              controller: ScrollController(), //just add this line
              itemCount: playlists.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: .75,
              ),
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      GoRouter.of(context).push(
                        '/playlist/${playlist.id}',
                      );
                    },
                    child: LargePlaylistCard(playlist: playlists[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
