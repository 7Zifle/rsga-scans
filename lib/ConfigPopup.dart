import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'dart:io';
import 'dart:convert'; //to convert json to maps and vice versa

final _formKey = GlobalKey<FormState>();

final _usernameController = TextEditingController();
final _passwordController = TextEditingController();
final _dirController = TextEditingController();

String configPath() {
  String configFile = "";
  Map<String, String> envVars = Platform.environment;
  if (Platform.isMacOS || Platform.isLinux) {
    configFile = envVars['HOME'] + "/.scans-config.json";
  } else if (Platform.isWindows) {
    configFile = envVars['UserProfile'] + '\\.scans-config.json';
  }
  return configFile;
}

void _submitScanInfo() {
  Map<String, dynamic> jsonData = {
    "username": _usernameController.value.text,
    "password": _passwordController.value.text,
    "dir": _dirController.value.text,
  };

  final jsonString = jsonEncode(jsonData);
  final filePath = new File(configPath());
  filePath.writeAsString(jsonString);
  GlobalConfiguration().add(jsonData);
}

Widget buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('User Config Missing'),
    content: new Form(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Enter User Config to begin using the scans program."),
          TextFormField(
            controller: _dirController,
            decoration: const InputDecoration(
              hintText: 'Enter Directory name',
            ),
          ),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              hintText: 'Enter username',
            ),
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
                hintText: 'Enter password'
            )),
            ElevatedButton(
              onPressed: () {
                _submitScanInfo();
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
        ],
      ),
    ),
  );
}