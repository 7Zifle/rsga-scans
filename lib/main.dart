import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:global_configuration/global_configuration.dart';

import 'ConfigPopup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RGSA Scans App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    DesktopWindow.setWindowSize(Size(480, 600));
    final configFile = new File(configPath());

    if (configFile.existsSync()) {
      String jsonString = configFile.readAsStringSync();
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      GlobalConfiguration().add(jsonData);
    }
    super.initState();
  }

  Widget buildPopupRetrieving(BuildContext context) {
    return new AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 45.0),
              child: CircularProgressIndicator()),
          Text('Retrieving Scans.'),
        ],
      ),
    );
  }

  Future<bool> downloadScans() async {
    final conf = GlobalConfiguration();
    FTPConnect ftp = FTPConnect('10.150.0.18',
        user: conf.getValue('username'), pass: conf.getValue('password'));
    if (await ftp.connect() == false) {
      return false;
    }
    if (await ftp.changeDirectory(conf.getValue('dir')) == false) {
      return false;
    }
    List<String> fileNames = await ftp.listDirectoryContentOnlyNames();
    for (var i = 0; i < fileNames.length; i++) {
      var element = fileNames[i];
      bool res = await ftp.downloadFile(element, File('C:\\Scans\\' + element));
      if (res == true) {
        await ftp.deleteFile(element);
      }
    }
    //TODO delete files in scans folder
    await ftp.disconnect();
    return true;
  }

  void resultSnack(bool res) {
    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully Retrieved Scans!')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed retrieving scans!')));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset('assets/img/rgsa-logo-lg.png'),
              margin: EdgeInsets.only(bottom: 50.0),
            ),
            Text(
              'Simply press the start scans button below to retrieve your scans!',
            ),
            Container(
              width: 150.0,
              height: 45.0,
              margin: EdgeInsets.only(top: 50.0),
              child: ElevatedButton(
                child: Text('Start Scans'),
                onPressed: () {
                  final conf = GlobalConfiguration();
                  if (conf.getValue("username") == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          buildPopupDialog(context),
                    );
                  } else {
                    final popup = buildPopupRetrieving(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => popup,
                    );
                    downloadScans().then((value) => resultSnack(value));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
