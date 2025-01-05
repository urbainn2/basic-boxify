import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserSettingToggles extends StatelessWidget {
  const UserSettingToggles({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final artistBloc = context.read<ArtistBloc>();
    final state = artistBloc.state;
    final user = state.user;
    return SizedBox(
      height: 180,
      width: 200,
      child: ListView(
        children: [
          SwitchListTile(
            title: Text('admin'.translate()),
            value: user.admin,
            dense: true,
            onChanged: (bool value) {
              artistBloc.add(
                ArtistToggleUserSettings(
                  user: user,
                  field: 'admin'.translate(),
                  value: user.admin,
                ),
              );
            },
          ),

          // banned
          SwitchListTile(
            title: Text('banned'.translate()),
            value: state.user.banned,
            dense: true,
            onChanged: (bool value) {
              context.read<ArtistBloc>().add(
                    ArtistToggleUserSettings(
                      user: state.user,
                      field: 'banned'.translate(),
                      value: state.user.banned,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
