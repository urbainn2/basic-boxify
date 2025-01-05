import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteAccountTile extends StatelessWidget {
  DeleteAccountTile({
    Key? key,
    required this.context,
    required this.id,
    this.style,
  }) : super(key: key);

  final BuildContext context;
  final String id;
  TextStyle? style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return id != ''
        ? ListTile(
            title: Text('warningDelete'.translate(), style: style),
            trailing: ElevatedButton(
              onPressed: () async {
                _showConfirmationDialog(context);
              },
              style: roundedButtonStyleRed,
              child: Text(
                'deleteAccount'.translate(),
                style: style,
              ),
            ),
          )
        : Container();
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('deleteAccount'.translate()),
          content: Text('confirmDelete'.translate()),
          actions: <Widget>[
            TextButton(
              child: Text('cancelSentenceCase'.translate()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('confirm'.translate()),
              onPressed: () async {
                Navigator.of(context).pop();
                // Show reauthentication dialog
                await _showReauthenticationDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showReauthenticationDialog(BuildContext context) async {
    String email = '';
    String password = '';
    final _formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Re-enter Credentials'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  initialValue: FirebaseAuth.instance.currentUser?.email,
                  validator: (value) =>
                      value != null && value.isNotEmpty ? null : 'Enter email',
                  onSaved: (value) => email = value ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'Enter password',
                  onSaved: (value) => password = value ?? '',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('cancelSentenceCase'.translate()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('confirm'.translate()),
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  Navigator.of(context).pop();
                  SettingsBloc settingsBloc =
                      BlocProvider.of<SettingsBloc>(context);
                  settingsBloc.add(ReauthenticateAndDeleteAccount(
                    id: id,
                    email: email,
                    password: password,
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
