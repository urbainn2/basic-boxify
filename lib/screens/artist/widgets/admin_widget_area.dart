import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

/// This widget is used to display a few of the admin controls for the user.
/// It is only visible to the user if they are an admin.
/// Controls returned include:
/// - UserInfo
/// - UserSettingToggles
class AdminWidgetArea extends StatefulWidget {
  final bool isAdmin;
  final User user;

  const AdminWidgetArea({
    Key? key,
    required this.isAdmin,
    required this.user,
  }) : super(key: key);

  @override
  _AdminWidgetAreaState createState() => _AdminWidgetAreaState();
}

class _AdminWidgetAreaState extends State<AdminWidgetArea> {
  bool _isAdminExpanded = false;

  @override
  Widget build(BuildContext context) {
    // If the user is not an admin, don't build anything.
    if (!widget.isAdmin) return SizedBox.shrink();

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isAdminExpanded = !_isAdminExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                'adminControls'.translate(),
              ),
              tileColor: Core.appColor.primaryColor,
            );
          },
          body: Column(
            children: [
              UserInfo(user: widget.user),
              UserSettingToggles(context: context)
            ],
          ),
          isExpanded: _isAdminExpanded,
        ),
      ],
    );
  }
}
