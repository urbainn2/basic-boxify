import 'dart:async';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:boxify/app_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:file_picker/file_picker.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  _ArtistScreenState createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen>
    with SingleTickerProviderStateMixin, ScrollListenerMixin {
  late String userId;
  ap.AudioPlayer? audioPlayer;
  bool adminControlsOpened = false;
  bool isLoggedIn = false;
  bool? badUserIdPassed;
  User? user;
  User? viewer;
  String version = '';
  final GlobalKey<FormState> _editArtistFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    audioPlayer = ap.AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer!.dispose();
    usernameController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  Future<void> _play(String? url) async {
    // logger.i(url);
    if (url == null) {
      return;
    }
    url = url.replaceFirst('dl=0', 'raw=1');

    try {
      await audioPlayer!.play(ap.UrlSource(url));
    } catch (e) {
      // Handle the error, possibly by showing a user-friendly message
      logger.e('Error playing audio: $e');
    }
  }

  // All the dialogs in the artist profile were being pushed to the root navigator,
  // that has a lower priority than the nested navigators used in the app and by the router.
  // Because of that, the dialog was popped only when the other navigators with higher priority
  // had an empty stack, leading to issue #21
  void _openBundlePreview(Bundle bundle) {
    final songList = bundle.songList?.split(',');
    if (bundle.preview!.isNotEmpty) {
      _play(bundle.preview);
    }

    showDialog(
      useRootNavigator:
          false, // Do not push the dialog to the root navigator stack.
      context: context,
      barrierDismissible:
          true, // User can dismiss dialog by tapping anywhere outside of dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Column(
            children: [
              if (bundle.image != null)
                SizedBox(
                  height: 200,
                  child: CachedNetworkImage(
                    imageUrl: bundle.image!.replaceAll('dl=0', 'raw=1'),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )
              else
                Text(bundle.image.toString()),
              Text(bundle.title!),
            ],
          ),
          content: Column(
            children: [
              Text(bundle.description ?? ''),
              const SizedBox(height: 20),
              Expanded(
                child: SizedBox(
                  height: 220,
                  width: 240,
                  child: ListView.builder(
                    itemCount: songList?.length,
                    itemBuilder: (context, index) => Text(
                      songList![index],
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'close'.translate(),
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                if (audioPlayer!.state == ap.PlayerState.playing) {
                  audioPlayer!.stop();
                }
                Navigator.of(dialogContext).pop();
              },
            ),
            if (kIsWeb && !bundle.isOwned! == false)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Core.appColor.primary,
                ),
                onPressed: () {
                  audioPlayer!.stop();
                  launchURL(
                    Core.app.marketUrl,
                  );
                },
                child: Text('buy'.translate()),
              )
            else
              Container(),
          ],
        );
      },
    ).then((_) {
      // This block is triggered when the dialog is dismissed in any way (including tapping outside)
      if (audioPlayer!.state == ap.PlayerState.playing) {
        audioPlayer!.stop();
      }
    });
  }

  void _openBadgePreview(badge) {
    showDialog(
      useRootNavigator:
          false, // Do not push the dialog to the root navigator stack.
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Column(
          children: [
            if (badge.icon != null)
              SizedBox(
                height: 200,
                child: badge.icon,
              )
            else
              Text(badge.icon.toString()),
            Text(badge.title!),
          ],
        ),
        content: Column(
          children: [
            Text(badge.description ?? ''),
            const SizedBox(height: 20),
            Text(badge.powers ?? ''),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Close'.translate(),
              style: TextStyle(color: Colors.grey),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showBundleController(BuildContext context) {
    return showDialog(
      useRootNavigator:
          false, // Do not push the dialog to the root navigator stack.
      context: context,
      builder: (_) {
        final profileState = context.read<ArtistBloc>().state;
        final allBundles = profileState.allBundles;
        final user = profileState.user;
        final username = user.username;
        var updated = false;
        return AlertDialog(
          title: DialogTitle(itemName: 'Packs', username: username),
          content: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 200,
              child: ListView.builder(
                itemCount: allBundles.length,
                itemBuilder: (dialogContext, index) {
                  final bundle = allBundles[index];
                  final title = bundle.title;
                  return StatefulBuilder(
                    builder:
                        (BuildContext switchContext, StateSetter setState) {
                      return SwitchListTile(
                        title: Text(title!),
                        value: user.bundleIds.contains(bundle.id),
                        dense: true,
                        onChanged: (bool value) {
                          setState(() {
                            updated = true;
                            context.read<ArtistBloc>().add(
                                  ArtistAddRemoveUserBundles(
                                    user: user,
                                    bundleId: bundle.id!,
                                    value: user.bundleIds.contains(bundle.id),
                                  ),
                                );
                          });
                          user.bundleIds.contains(bundle.id)
                              ? user.bundleIds.remove(bundle.id)
                              : user.bundleIds.add(bundle.id!);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // // if admin changed bundles on their own profile, force fetch
                if (profileState.isCurrentUser && updated) {
                  // logger.i(
                  //     'ARTIST SCREEN hash= ${identityHashCode(context.read<UserBloc>())}');
                  // context.read<UserBloc>().add(const ClearSearch());

                  final mc =
                      context.read<MetaDataCubit>().state as MetaDataLoaded;
                  final serverRatingsUpdated = mc.serverTimestamps['ratings2'];
                  context.read<UserBloc>().add(
                        LoadUser(
                            serverRatingsUpdated: serverRatingsUpdated!,
                            clearCache: true),
                      );
                } else {
                  logger.i('not updated');
                }
                context.pop();
              },
              child: Text('close'.translate()),
            ),
          ],
        );
      },
    );
  }

  Future _showBadgeController(BuildContext context) {
    return showDialog(
      useRootNavigator:
          false, // Do not push the dialog to the root navigator stack.
      context: context,
      builder: (_) {
        final user = context.read<ArtistBloc>().state.user;
        final username = user.username;
        return AlertDialog(
          title: DialogTitle(itemName: 'Badges', username: username),
          content: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 200,
              child: ListView.builder(
                itemCount: badges.length,
                // important: rename context to dialogContext so doesn't overwrite artistBloc
                itemBuilder: (dialogContext, index) {
                  final badge = badges[index];
                  final title = badge.title;
                  return StatefulBuilder(
                    builder:
                        (BuildContext switchContext, StateSetter setState) {
                      return SwitchListTile(
                        title: Text(title!),
                        value: user.badges.contains(title),
                        dense: true,
                        onChanged: (bool value) {
                          setState(() {
                            context.read<ArtistBloc>().add(
                                  ArtistAddRemoveUserBadges(
                                    user: user,
                                    field: badge.title!,
                                    value: user.badges.contains(title),
                                  ),
                                );
                            user.badges.contains(badge.title)
                                ? user.badges.remove(badge.title)
                                : user.badges.add(badge.title);
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('done'.translate()),
              onPressed: () {
                context.pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> showChangeUsernameDialog(BuildContext context) async {
    final state = context.read<ArtistBloc>().state;
    final user = state.user;
    final username = user.username;
    usernameController.text = username;

    return showDialog(
      context: context,
      useRootNavigator:
          false, // Do not push the dialog to the root navigator stack.
      builder: (context) {
        myFocusNode.requestFocus();
        return SizedBox(
          width: 300,
          child: AlertDialog(
            title: Text("changeUsername".translate()),
            elevation: 24,
            content: TextField(
              controller: usernameController,
              focusNode: myFocusNode,
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: Text('cancel'.translate()),
              ),
              ElevatedButton(
                child: Text('saveCap'.translate()),
                onPressed: () {
                  context.read<ArtistBloc>().add(
                        ArtistChangeUsername(
                          user: user,
                          newUsername: usernameController.text,
                        ),
                      );

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _imageForEditDetails(ArtistState state, setState) {
    logger.i('_imageForEditDetails for ${state.user.username}');

    // setState(() {
    // Else if the state has a recently picked image on web, return that.
    if (kIsWeb && (state.profileImageOnWeb != null)) {
      logger.i('_imageForEditDetails: there is a state.profileImageOnWeb:');
      // return Image.memory(state.pngByteData!);
      return UserArtistImage(
        radius: 110,
        pngByteData: state.pngByteData!,
      );
    } else if (!kIsWeb && (state.profileImage != null)) {
      logger.i('_imageForEditDetails: there is a state.profileImage');
      // return Image.file(state.profileImage!, fit: BoxFit.cover);
      return UserArtistImage(
        radius: 110,
        profileImage: state.profileImage!,
      );
    } else {
      logger.i(
        '_imageForEditDetails: there is no state.profileImage or state.profileImageOnWeb',
      );
      return UserArtistImage(
        radius: 110,
        profileImageUrl: state.user.profileImageUrl,
      );
    }
    // });

    // if (state.profileImage != null) {
    //   logger.i("_imageForEditDetails: there is a state.profileImage");
    //   return Image.file(state.profileImage!, fit: BoxFit.cover);
    // } else if (state.profileImageOnWeb != null) {
    //   logger.i("_imageForEditDetails: there is a state.profileImageOnWeb:");
    //   return Image.memory(state.pngByteData!);
    // } else {
    //   logger.i("_imageForEditDetails: there is no state.profileImage or state.profileImageOnWeb");
    //   return UserArtistImage(
    //     radius: 110,
    //     profileImageUrl: state.user.profileImageUrl,
    //   );
    // }
  }

  Future _editArtist(ArtistState state) {
    final myBloc = BlocProvider.of<ArtistBloc>(context);
    return showDialog(
      context: context,
      useRootNavigator:
          false, // Do not push the dialog to the root navigator stack.
      builder: (context) {
        return BlocProvider<ArtistBloc>.value(
          value: myBloc,
          child: BlocBuilder<ArtistBloc, ArtistState>(
            builder: (context, state) {
              return AlertDialog(
                insetPadding: EdgeInsets.zero,
                title: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Pop the dialog context
                          },
                        ),
                        // Text('editProfile'.translate(), style: boldWhite14),
                        BlocBuilder<ArtistBloc, ArtistState>(
                          builder: (context, state) {
                            return GestureDetector(
                              child: Text('save'.translate(), style: grey14),
                              onTap: () {
                                final myBloc =
                                    BlocProvider.of<ArtistBloc>(context);
                                myBloc.add(SubmitArtist());

                                // This is awesome! We can listen to the stream of the Bloc
                                // Close the dialog when the status changes to success
                                myBloc.stream.listen((state) {
                                  if (state.status == ArtistStatus.success) {
                                    Navigator.of(context)
                                        .pop(); // Ensure this is called in the UI, not the Bloc
                                  }
                                });
                              },
                            );
                          },
                        )
                      ],
                    )
                  ],
                ),
                content: BlocBuilder<ArtistBloc, ArtistState>(
                  builder: (context, state) {
                    logger.i("rebuilding");
                    return Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (state.status == ArtistStatus.submitting)
                              linearProgress,

                            /// Artist image
                            GestureDetector(
                              onTap: () =>
                                  _selectArtistImage(context, setState),
                              child: _imageForEditDetails(state, setState),
                            ),

                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('changePhoto'.translate(),
                                  style: white10),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Form(
                                key: _editArtistFormKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      initialValue: state.user.bio,
                                      decoration: InputDecoration(
                                        hintText: 'bio'.translate(),
                                      ),
                                      onChanged: (value) {
                                        if (_debounce?.isActive ?? false) {
                                          _debounce!.cancel();
                                        }
                                        _debounce = Timer(
                                            const Duration(milliseconds: 500),
                                            () {
                                          // Dispatch the bio changed event after 500ms of inactivity
                                          context
                                              .read<ArtistBloc>()
                                              .add(BioChanged(bio: value));
                                        });
                                      },
                                      validator: (value) =>
                                          value!.trim().isEmpty
                                              ? 'bioCannotBeEmpty'.translate()
                                              : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _selectArtistImage(BuildContext context, setState) async {
    /// Web App
    if (kIsWeb) {
      logger.i('pickin file on web !');
      final result = await FilePicker.platform.pickFiles(withData: true);
      final file = result!.files.first;
      final pngByteData = result.files.first.bytes;
      if (pngByteData != null) {
        logger.i('got the file result');

        setState(() {
          context.read<ArtistBloc>().add(
                ArtistImageChangedOnWeb(file: file, pngByteData: pngByteData),
              );
        });
      } else {
        logger.i('no result from filepicker');
        // User canceled the picker
      }
    }

    /// Mobile App
    else {
      final pickedFile = await ImageHelper.pickImageFromGallery(
        context: context,
        cropStyle: CropStyle.circle,
        title: 'Artist Image',
      );
      if (pickedFile != null) {
        context.read<ArtistBloc>().add(ArtistImageChanged(image: pickedFile));
      }
    }
  }

  Timer? _debounce;

  // void _submitForm(
  //   BuildContext context,
  //   // bool isSubmitting,
  //   File? profileImage,
  //   dynamic pngByteData,
  // ) {
  //   // logger.i('isSubmitting == $isSubmitting');
  //   logger.i('profileImage == null ${profileImage == null}');
  //   logger.i('pngByteData == null ${pngByteData == null}');

  //   final validated = _editArtistFormKey.currentState!.validate();
  //   logger.i('validated == $validated');
  //   if (validated && profileImage != null && pngByteData == null) {
  //     logger.i('_submitForm adding SubmitArtist');
  //     context.read<ArtistBloc>().add(const SubmitArtist());
  //   } else if (validated && pngByteData != null) {
  //     logger.i('_submitForm adding SubmitArtistOnWeb');
  //     context.read<ArtistBloc>().add(const SubmitArtistOnWeb());
  //   } else if (validated) {
  //     logger.i('_submitForm has text but no image, calling SubmitArtist');
  //     context.read<ArtistBloc>().add(const SubmitArtist());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (badUserIdPassed == true) {
      return const ErrorPage();
    }
    return BlocConsumer<ArtistBloc, ArtistState>(
      listener: (context, state) {
        if (state.status == ArtistStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              content: state.failure.message.toString(),
            ),
          );
        }
      },
      builder: (context, state) {
        if (context.read<AuthBloc>().state.user == null) {
          logger.i(
              'artistScreen: AuthBloc.state.user == null so return CircularProgressIndicator()');
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == ArtistStatus.loading ||
            state.status == ArtistStatus.initial) {
          logger.i(
              'artistScreen: ArtistStatus.loading so return CircularProgressIndicator()');
          return circularProgressIndicator;
        }
        logger.i('ARTIST SCREEN build for ${state.user.username}');

        final screenSize = MediaQuery.of(context).size;
        final screenWidth = screenSize.width;
        final isLargeScreen = screenWidth > Core.app.largeSmallBreakpoint;
        final isLoggedIn = !state.user.isAnonymous;
        final admin = state.viewer.admin;
        final user = state.user;
        final viewer = state.viewer;
        final userPlaylists = state.userPlaylists;
        final isCurrentUser = user.id == viewer.id;
        final fontSize = isLargeScreen ? 80.0 : 50.0;
        final artistState = context.read<ArtistBloc>().state;
        final sectionPadding = EdgeInsets.all(14.0);
        final crossAxisCount = screenWidth ~/ 250;

        return
            // Give the custom scroll view a non-scrolling background
            SafeArea(
          child: Stack(
            children: [
              // This stays still while the CustomScrollView scrolls
              BackgroundImage(
                profileImageUrl: user.profileImageUrl,
              ),
              CustomScrollView(
                controller: scrollController,
                slivers: [
                  // APP BAR
                  SliverAppBarNoExpand(
                    expandedHeight: kToolbarHeight,
                    appBarBackgroundOpacity: appBarBackgroundOpacity,
                    titleOpacity: titleOpacity,
                    title: user.username,
                    color: Core.appColor.hoverSelectedColor,
                    type: SliverAppBarNoExpandType.artist,
                    actions: [
                      sizedBox16,
                      SearchButton(
                        targetPath: '/search',
                        toolTipText: 'whoDoYouWantToSee'.translate(),
                      ),
                      isCurrentUser ? SettingsButton() : Container(),
                    ],
                  ),

                  // USERNAME box. Will become opaque when scrolled up under the app bar
                  SliverToBoxAdapter(
                    child: Container(
                      height: 220,
                      color: Core.appColor.hoverSelectedColor
                          .withOpacity(appBarBackgroundOpacity),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onLongPress: () {
                            if (artistState.viewer.admin) {
                              showChangeUsernameDialog(context);
                            }
                          },
                          child: Padding(
                            padding: sectionPadding,
                            child: Text(
                              user.username,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // EDIT BUTTON, BUNDLES, BADGES, PLAYLISTS
                  SliverToBoxAdapter(
                    child: Container(
                      color: Core.appColor.scaffoldBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isCurrentUser && isLoggedIn)
                            Container(
                              child: Padding(
                                padding: sectionPadding,
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => {_editArtist(state)},
                                      style: roundedButtonStyleBlack,
                                      child: Text(
                                        'edit'.translate(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Container(),

                          // BUNDLES
                          if (state.bundles.isNotEmpty || admin)
                            isLargeScreen
                                ? BundlesForLargeArtist(
                                    sectionHeight: getLargeSectionHeight(
                                        state.bundles.length, crossAxisCount),
                                    bundles: state.bundles,
                                    openBundlePreview: _openBundlePreview,
                                  )
                                : SmallMediaSection(
                                    name: 'bundles'.translate(),
                                    mediaItems: state.bundles,
                                    onTap: _openBundlePreview,
                                  )
                          else
                            Container(),
                          // Add remove BUNDLES button
                          if (admin)
                            Center(
                              child: AddBundleButton(
                                onPressed: () => _showBundleController(context),
                              ),
                            )
                          else
                            Container(),

                          // SIGNUP / LOGIN
                          Container(
                            child: isLoggedIn
                                ? Container()
                                : signUpButton(context),
                          ),

                          Container(
                            child:
                                isLoggedIn ? Container() : logInButton(context),
                          ),
                          // BADGES
                          if (state.badges.isNotEmpty || admin)
                            isLargeScreen
                                ? BadgesForLargeArtist(
                                    sectionHeight: getLargeSectionHeight(
                                        state.badges.length, crossAxisCount),
                                    badges: state.badges,
                                    openBadgePreview: _openBadgePreview,
                                  )
                                : SmallMediaSection(
                                    name: 'badges'.translate(),
                                    mediaItems: state.badges,
                                    onTap: _openBadgePreview,
                                  )
                          else
                            Container(),
                          // Add remove badges button
                          if (admin)
                            Center(
                              child: SizedBox(
                                width: 100,
                                child: Card(
                                  shape: BeveledRectangleBorder(
                                    side: BorderSide(
                                      color: Core.appColor.primary,
                                      width: .3,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _showBadgeController(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Core.appColor.primary,
                                        ),
                                        child: const Icon(Icons.add),
                                      ),
                                      Center(
                                        child: Text(
                                          'add'.translate(),
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          else
                            Container(),
                          // PLAYLISTS
                          if (userPlaylists.isNotEmpty || admin)
                            isLargeScreen
                                ? PlaylistsForLargeArtist(
                                    sectionHeight: getLargeSectionHeight(
                                        state.userPlaylists.length, crossAxisCount),
                                        
                                    playlists: userPlaylists,
                                  )
                                : SmallMediaSection(
                                    name: 'playlists'.translate(),
                                    mediaItems: userPlaylists,
                                  )
                          else
                            Container(),

                          AdminWidgetArea(
                            isAdmin: admin,
                            user: user,
                          ),

                          SmallSection(
                              name: 'About',
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                ),
                                child: BlocBuilder<ArtistBloc, ArtistState>(
                                  builder: (context, state) {
                                    return Text(
                                      state.user.bio ?? '',
                                      style: const TextStyle(fontSize: 14),
                                    );
                                  },
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
