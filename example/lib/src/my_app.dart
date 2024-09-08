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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Easy Device Media'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  DeviceMediaServiceImpl()
                      .openPickImage(DeviceMediaSource.gallery, needCrop: true)
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
                child: const Text('Pick Image(Crop)'),
              ),
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
        
               Text(_path),
              if (_path.isNotEmpty)
                _path.contains('blob')
                    ? Image.asset(_path)
                    : Image.file(getFile(_path)),
            ],
          ),
        ),
      ),
    );
  }
}
