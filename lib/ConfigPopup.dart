import 'package:flutter/material.dart';
import 'dart:io' show Platform, stdout;

final _dirKey = GlobalKey<FormState>();
final _userKey = GlobalKey<FormState>();
final _passKey = GlobalKey<FormState>();

_submitScanInfo() {
  String os = Platform.operatingSystem;
  String home = "";
  Map<String, String> envVars = Platform.environment;
  if (Platform.isMacOS) {
    home = envVars['HOME'];
  } else if (Platform.isLinux) {
    home = envVars['HOME'];
  } else if (Platform.isWindows) {
    home = envVars['UserProfile'];
  }
  final configFile = home + "/.scans-config.json";
  print(configFile);
}

Widget buildPopupDialog(BuildContext context) {
  final TextEditingController _controller = new TextEditingController();

  return new AlertDialog(
    title: const Text('User Config Missing'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Enter User Config to begin using the scans program."),
        TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Enter Directory name',
          ),
        ),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Enter username',
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Enter password'
          ),
        )
      ],
    ),
    actions: <Widget>[
      new TextButton(
        onPressed: () {
          _submitScanInfo();
          Navigator.of(context).pop();
        },
        child: const Text('Close'),
      ),
    ],
  );
}