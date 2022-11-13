import 'package:easy_device_media/device_media.dart';
import 'package:flutter/material.dart';

import 'platforms/platform_io.dart'
    if (dart.library.html) './platforms/web_io.dart'
    if (dart.library.io) './platforms/mobile_io.dart' show getFile;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _path = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_path.isNotEmpty) Text(_path),
            if (_path.isNotEmpty)
              _path.contains('blob')
                  ? Image.asset(_path)
                  : Image.file(getFile(_path)),
            ElevatedButton(
              onPressed: () {
                DeviceMediaServiceImpl()
                    .openPickImage(DeviceMediaSource.gallery)
                    .then(
                  (value) {
                    if (value?.isNotEmpty ?? false) {
                      setState(() {
                        _path = value!;
                      });
                    }
                  },
                );
              },
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                DeviceMediaServiceImpl().openPickVideo().then(
                  (value) {
                    if (value?.isNotEmpty ?? false) {
                      setState(() {
                        _path = value!;
                      });
                    }
                  },
                );
              },
              child: const Text('Pick Video'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
