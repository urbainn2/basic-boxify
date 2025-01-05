import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SmallAddButton extends StatelessWidget {
  const SmallAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        backgroundColor: Colors.black12,
        side: const BorderSide(color: Colors.white), // set the background color
        textStyle: TextStyle(fontSize: 10, color: Colors.grey[500]),
      ),
      onPressed: () {
        GoRouter.of(context).push('playerSearch');
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Text('addSongs'.translate()),
      ),
    );
  }
}
