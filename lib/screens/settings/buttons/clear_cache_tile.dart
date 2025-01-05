// import 'package:app_core/app_core.dart';  //

import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClearCacheText extends StatelessWidget {
  const ClearCacheText({super.key, required this.context, required this.id});

  final BuildContext context;
  final String id;

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('clearCacheQuestion'.translate()),
          content: Text('yourDownloadsWontBeRemoved'.translate()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: Text('cancelSmall'.translate()),
            ),
            TextButton(
              onPressed: () async {
                CacheHelper cacheHelper = CacheHelper();
                cacheHelper.clearAll(
                    BlocProvider.of<AuthBloc>(context).state.user!.uid);
                BlocProvider.of<AuthBloc>(context).add(AuthLogoutRequested());
                BlocProvider.of<LoginCubit>(context).reset();

                // Push to login screen using GoRouter
                GoRouter.of(context).push('/login');

                Navigator.of(dialogContext).pop(); // Close the dialog

                showMySnack(
                  context,
                  message: 'yourCacheHasBeenCleared'.translate(),
                );
              },
              child: Text('clear'.translate()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return id != ''
        ? ListTile(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // children: [
            title: Text(
              'clearCache'.translate(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // SizedBox(height: 4),
            subtitle: Text(
              'youCanFree'.translate(),
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            trailing: ElevatedButton(
              style: roundedButtonStyleBlack,
              child: Text(
                'clearCache'.translate(),
                // style: boldWhite12,
              ),
              onPressed: () {
                _showConfirmationDialog(context);
              },
            ),
            // ],
          )
        : Container();
  }
}

// class ClearCacheButton extends StatelessWidget {
//   const ClearCacheButton({super.key, required this.context, required this.id});

//   final BuildContext context;
//   final String id;

//   @override
//   Widget build(BuildContext context) {
//     return id != ''
//         ? ListTile(
//             title: Text('Warning: this will clear your cached.'),
//             trailing: ElevatedButton(
//               onPressed: () async {
//                 CacheHelper cacheHelper = CacheHelper();
//                 cacheHelper.clearAll(context.read<AuthBloc>().state.user!.uid);
//                 context.read<AuthBloc>().add(AuthLogoutRequested());
//                 context.read<LoginCubit>().reset();
//                 // push to login screen
//                 GoRouter.of(context).push(
//                   '/login',
//                 );
//                 // context.read<AuthBloc>().add(AuthLogoutRequested());
//                 // context.read<LoginCubit>().reset();
//                 // context.read<MetaDataCubit>().reset();
//                 // context.read<UserBloc>().add(InitialState());
//                 // context.read<MarketBloc>().add(InitialMarketState());
//                 // context.read<TrackBloc>().add(TrackReset());
//                 // context.read<PlaylistBloc>().add(InitialPlaylistState());
//                 // context.read<SearchBloc>().add(ResetSearch());

//                 showMySnack(
//                   context,
//                   message: 'yourCacheHasBeenCleared'.translate(),
//                 );
//               },
//               style: ButtonStyle(
//                 backgroundColor:
//                     MaterialStateProperty.all<Color>(Colors.transparent!),
//                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                   RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(18),
//                     side: const BorderSide(color: Colors.grey),
//                   ),
//                 ),
//               ),
//               child: const Text(
//                 'Clear Cache',
//               ),
//             ),
//           )
//         : Container();
//   }
// }
