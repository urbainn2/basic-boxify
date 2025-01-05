import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LetsAddSomething extends StatelessWidget {
  ///
  const LetsAddSomething({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryBloc, LibraryState>(
      listener: (context, state) {
        if (state.status == LibraryStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              content: Text('playlistCreated'.translate()),
            ),
          );
        } else if (state.status == LibraryStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              content: state.failure.message,
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'letsFindSomethingForYourPlaylist'.translate(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(children: []),
            if (state.status == LibraryStatus.submitting)
              const LinearProgressIndicator(),
            LargeTrackSearchWidget()
          ],
        );
      },
    );
  }
}

class LetsAddSomethingTouch extends StatelessWidget {
  const LetsAddSomethingTouch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'letsFindSomethingForYourPlaylist'.translate(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBarForAddToPlaylist(),
            ),
            SmallTrackSearchResults(
              // showSpacer: false,
              screenType: SearchResultType.addToPlaylist,
            ),
          ],
        );
      },
    );
  }
}
