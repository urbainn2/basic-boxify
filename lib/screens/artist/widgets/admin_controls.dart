import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required User user,
  }) : _user = user;

  final User _user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Table(
            children: [
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'id: ',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(_user.id),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'registeredOn: ',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: _user.registeredOn != null
                        ? Text(
                            formatter.format(_user.registeredOn!.toDate()),
                          )
                        : const Text('-'),
                    // Text(''),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'lastSeen: ',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: _user.lastSeen != null
                        ? Text(
                            formatter2.format(_user.lastSeen!.toDate()),
                          )
                        : const Text('-'),
                    // Text(''),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
