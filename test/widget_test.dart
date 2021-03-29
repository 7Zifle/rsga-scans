// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rgsascans/main.dart';
import 'package:ftpconnect/ftpconnect.dart';

void main() async {
  group('ftp', () {
    FTPConnect ftp;
    setUpAll(() async {
      ftp = FTPConnect(
          '10.150.0.18', user: 'scans.acc', pass: 'x789n');
      await ftp.connect();
    });
    test('should be able to check directory', () async {
      expect(await ftp.checkFolderExistence('green'), true);
      expect(await ftp.changeDirectory('..'), true);
    });
    test('should be able to list contents in  directory', () async {
      expect(await ftp.changeDirectory('green'), true);
      expect((await ftp.listDirectoryContentOnlyNames()).length > 0, true);
      expect(await ftp.changeDirectory('..'), true);
    });
    test('should be able to download contents to test dir', () async {
      expect(await ftp.changeDirectory('green'), true);
      var dir = Directory('/home/r3aper/src/rgsascans/test_scans');
      dir.create();
      List<String> fileNames = await ftp.listDirectoryContentOnlyNames();
      for (var i = 0; i  < fileNames.length; i++) {
        var element = fileNames[i];
        bool res = await ftp.downloadFile(element, File('/home/r3aper/src/rgsascans/test_scans/' + element));
        expect(res, true);
      }
      expect(await ftp.changeDirectory('..'), true);
      dir = Directory('/home/r3aper/src/rgsascans/test_scans');
      dir.deleteSync(recursive: true);
    });
    tearDownAll(() async {
      await ftp.disconnect();
    });
  });
}
