import 'package:boxify/app_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class MyRouter {
  MyRouter();

  GoRouter get router => GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: '/library',
        debugLogDiagnostics: true,

        // redirect to the login page if the user is not logged in
        redirect: (BuildContext context, GoRouterState state) {
          final auth.User? authUser = context.read<AuthBloc>().state.user;
          final String requestedPage = state.matchedLocation;

          /// if there is no firebase auth User session
          /// and not trying to access the signup screen
          /// redirect the user to the login page
          ///
          /// Redirect users without a Firebase auth session user to the login page.
          /// Unless they're trying to signup, in which case, let them go to the signup page or username page.
          if (authUser == null &&
              requestedPage != '/signup' &&
              requestedPage != '/username') {
            //<- this was the problem. Never turn this back on.
            // if (authUser == null) {
            return '/login';
          }

          /// ALSO NOW I WANT TO GUARD SOME ROUTES IN THE BASIC APP
          if (Core.app.type == AppType.basic) {
            if (requestedPage == '/signup' ||
                    requestedPage == '/username' ||
                    requestedPage == '/market' ||
                    requestedPage == '/search' ||
                    requestedPage == '/smallAddToPlaylist'
                // ||
                // requestedPage == '/user/:userId'
                ) return '/';
          }

          return null;
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/login',
            builder: (BuildContext context, GoRouterState state) {
              return LoginScreen();
            },
          ),

          GoRoute(
            path: '/signup',
            builder: (BuildContext context, GoRouterState state) {
              return SignupScreen();
            },
          ),
          GoRoute(
            path: '/username',
            builder: (BuildContext context, GoRouterState state) {
              return UsernameScreen();
            },
          ),

          /// Application shell
          ShellRoute(
            navigatorKey: shellNavigatorKey,
            builder: (BuildContext context, GoRouterState state, Widget child) {
              /// You don't want this full screen scaffold to have your app bar
              return ScaffoldWithPlayer(
                navigationShell: child,
              );
            },
            routes: <RouteBase>[
              GoRoute(
                path: '/lyrics',
                builder: (BuildContext context, GoRouterState state) {
                  return LyricsScreen();
                },
              ),

              /// '/' is the default route
              GoRoute(
                path: '/',
                builder: (BuildContext context, GoRouterState state) {
                  return HomeScreen();
                },
              ),

              /// '/' is the default route
              GoRoute(
                path: '/library',
                builder: (BuildContext context, GoRouterState state) {
                  return LibraryScreen();
                },
              ),

              /// PLAYLIST
              GoRoute(
                path: '/playlist/:playlistId',
                builder: (BuildContext context, GoRouterState state) {
                  final playlistId = state
                      .pathParameters['playlistId']; // Get "id" param from URL
                  return BasePlaylistScreen(playlistId: playlistId!);
                },
              ),

              /// Player Search
              GoRoute(
                path: '/playerSearch',
                builder: (BuildContext context, GoRouterState state) {
                  return SearchMusicScreen();
                },
              ),

              /// Small Add To Playlist
              GoRoute(
                path: '/smallAddToPlaylist',
                builder: (BuildContext context, GoRouterState state) {
                  return SmallAddToPlaylistScreen();
                },
              ),

              /// Market screen. Displayed when the second item in the the bottom navigation bar is selected.
              GoRoute(
                path: '/market',
                builder: (BuildContext context, GoRouterState state) {
                  logger.i('myapp.goRouter /market');
                  return const MarketScreen();
                },
              ),
              GoRoute(
                path: '/settings',
                builder: (BuildContext context, GoRouterState state) {
                  return SettingsScreen();
                },
              ),

              // http://localhost:59600/track/5fc779fb54c34485a7fcd8cecbce8d5d
              /// Track
              GoRoute(
                path: '/track/:trackId',
                builder: (BuildContext context, GoRouterState state) {
                  try {
                    final trackId = state
                        .pathParameters['trackId']; // Get "id" param from URL
                    logger.f('myRouter!! trackId: $trackId');
                    return TrackScreen(trackId: trackId!);
                  } catch (e) {
                    logger.e('Error routing track/:trackId $e');
                    // Redirect to a 'not found' page or another appropriate action
                    return ErrorPage(); // This could be a screen that indicates that the item was not found.
                  }
                },
              ),

              GoRoute(
                path: '/search',
                builder: (BuildContext context, GoRouterState state) {
                  return const SearchUserScreen();
                },
              ),

              /// Artist Screen
              GoRoute(
                path: '/user/:userId',
                builder: (BuildContext context, GoRouterState state) {
                  try {
                    final userId = state
                        .pathParameters['userId']; // Get "id" param from URL
                    logger.i('myapp.goRouter /user/:userId userId: $userId');

                    return ArtistScreen(userId: userId!);
                  } catch (e) {
                    logger.e('Error routing user/:userId $e');
                    // Redirect to a 'not found' page or another appropriate action
                    return ErrorPage(); // This could be a screen that indicates that the item was not found.
                  }
                },
              ),
            ],
          ),
        ],
      );
}
