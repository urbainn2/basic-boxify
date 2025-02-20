import 'package:boxify/app_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UsernameScreen extends StatelessWidget {
  UsernameScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    logger.i('username screen: build ');
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<UsernameCubit, UsernameState>(
          listener: (context, state) {
            if (state.status == UsernameStatus.error) {
              logger.i(state.failure.message.toString());
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  content: state.failure.message,
                  onPressed: () {
                    // Fix: Avoid double route stack pop in default function. In username_screen, only one route exists in the stack,
                    // so this custom callback pops it once to prevent an empty stack error that would cause the app to crash.
                    context.read<UsernameCubit>().reset();
                    context
                        .read<UsernameCubit>()
                        .usernameChanged(state.username);
                    Navigator.of(context).pop();
                  },
                ),
              );
            }
            if (state.status == UsernameStatus.initial) {
              logger.i('state.status == UsernameStatus.initial');
              logger.i(state.usernameIsValid);
              // Just in case they ended up here for some reason
              if (state.usernameIsValid) {
                logger
                    .i('UsernameStatus.initial but already valid so nav time');
                GoRouter.of(context).push('/library');
              }
            }
            if (state.status == UsernameStatus.success) {
              logger
                  .i('username saved, state.status == UsernameStatus.success');
              logger.i(state.usernameIsValid);
              if (state.usernameIsValid) {
                logger.i('valid so nav time');
                final metaDataLoaded =
                    context.read<MetaDataCubit>().state as MetaDataLoaded;
                final playlistBloc = context.read<PlaylistBloc>();
                playlistBloc.add(InitialPlaylistState());

                context.read<UserBloc>().add(LoadUser(
                    clearCache: true,
                    serverRatingsUpdated: metaDataLoaded
                        .serverTimestamps['ratings2']!)); // NOT AVAILABLE HERE
                // context.read<PlayerBloc>().add(const InitPlayer());
                context.read<ArtistBloc>().add(LoadArtist(
                    // userId: context.read<AuthBloc>().state.user!.uid));
                    viewer: context.read<UserBloc>().state.user));

                /// TODO: IS NOT LOADED YET
                GoRouter.of(context).go('/library');
              }
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Container(
                  constraints:
                      BoxConstraints(maxWidth: Core.app.signInBoxWidth),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Card(
                      // color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/mrn.png',
                                height: Core.app.smallRowImageSize,
                                // fit: BoxFit.cover
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'enterAUsername'.translate(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                decoration: const InputDecoration(
                                  // hintStyle: TextStyle(fontSize: 11.0),
                                  hintText: 'Username',
                                ),
                                onChanged: (value) => context
                                    .read<UsernameCubit>()
                                    .usernameChanged(value),
                                validator: (value) => value!.trim().isEmpty
                                    ? 'Please enter a valid username.'
                                    : null,
                              ),
                              const SizedBox(height: 28),
                              ElevatedButton(
                                onPressed: () async {
                                  _submitForm(
                                    context,
                                    state.status == UsernameStatus.submitting,
                                    state.username,
                                    context.read<AuthBloc>().state.user!,
                                  );
                                },
                                child: Text('save'.translate()),
                              ),
                              // const SizedBox(height: 12.0),
                              // ElevatedButton(
                              //   // elevation: 1.0,
                              //   // color: Colors.grey[200],
                              //   // textColor: Colors.black,
                              //   onPressed: () => Navigator.of(context).pop(),
                              //   child: const Text('Back to Login'),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm(
    BuildContext context,
    bool isSubmitting,
    String username,
    auth.User user,
  ) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<UsernameCubit>().saveUserRecord(username, user);
    }
  }
}
