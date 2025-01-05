import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:boxify/screens/search_user/cubit/search_user_cubit.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchUserScreen> {
  final TextEditingController _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('building Search screen');
    final userBloc = context.read<UserBloc>();
    return SafeArea(
      child: Scaffold(
        appBar: SearchUserBar(),
        body: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: BlocBuilder<SearchUserCubit, SearchUserState>(
            builder: (context, state) {
              switch (state.status) {
                case SearchUserStatus.error:
                  return CenteredText(state.failure.message!);
                case SearchUserStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case SearchUserStatus.loaded:
                  return state.users.isNotEmpty
                      ? ListView.builder(
                          itemCount: state.users.length,
                          itemBuilder: (BuildContext context, int index) {
                            final user = state.users[index];
                            return ListTile(
                              leading: UserArtistImage(
                                radius: 22,
                                profileImageUrl: user.profileImageUrl.isNotEmpty
                                    ? user.profileImageUrl
                                    : Core.app.gerbil,
                              ),
                              title: Text(
                                user.username,
                                style: const TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                context.read<ArtistBloc>().add(
                                      LoadArtist(
                                        viewer: userBloc.state.user,
                                        userId: user.id,
                                      ),
                                    );
                                GoRouter.of(context).push(
                                  '/user/${user.id}',
                                );
                              },
                            );
                          },
                        )
                      : const CenteredText('No users found');
                default:
                  return sizedBox;
              }
            },
          ),
        ),
      ),
    );
    //     ),
    //   ),
    // );
  }
}
