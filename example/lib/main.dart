import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:opencamera/opencamera.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String imagePath = "";
  final _openCameraPlugin = Opencamera();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    requestPermission();
  }

  requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      //Permission.storage,
    ].request();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _openCameraPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text('Running on: $_platformVersion\n'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await Permission.camera.request().isGranted) {
                    capturePhoto();
                  } else {
                    log("camera permission not granted");
                  }
                },
                child: const Text('Capture Image'),
              ),
              const SizedBox(height: 100),
              const Text('Image Path:'),
              Text(imagePath),
            ],
          ),
        ),
      ),
    );
  }

  capturePhoto() async {
    imagePath = await _openCameraPlugin.capturePhoto() ?? "";
    setState(() {});
  }
}
