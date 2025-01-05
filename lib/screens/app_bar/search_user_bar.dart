import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:boxify/screens/search_user/cubit/search_user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchUserBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  SearchUserBar({
    super.key,
  });

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchUserCubit = context.read<SearchUserCubit>();
    return AppBar(
        backgroundColor: Core.appColor.panelColor,
        title: MySearchTextField(
          textController:
              _textController, // Use the appropriate TextEditingController
          hintText: 'whoDoYouWantToSee'.translate(),
          onSearch: (value) {
            searchUserCubit.searchUsers(value);
          },
          onClear: () {
            searchUserCubit.clearSearch();
          },
        ));
  }
}
