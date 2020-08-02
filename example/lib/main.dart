import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() {
  SentryFlutter.init((o) {
    // NOTE: Replace the DSN below with your own from your project settings in Sentry.
    o.dsn =
        'https://39226a237e6b4fa5aae9191fa5732814@o19635.ingest.sentry.io/2078115';
    o.debug = true;
  },
      () =>
          // Create your root widget below:
          ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentry Flutter Example App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sentry Flutter Example App'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: const Text('Dart exception'),
              onPressed: () {
                throw StateError('This is a Dart exception.');
              },
            ),
            RaisedButton(
              child: const Text('SateError in async method'),
              onPressed: () async {
                Future<void> brokenState() async {
                  throw StateError('State error from async.');
                }

                await brokenState();
              },
            ),
            RaisedButton(
              child: const Text('Capture message'),
              onPressed: () async {
                await SentryFlutter.captureMessage('Capture message example.');
              },
            ),
            RaisedButton(
              child: const Text('Platform Exception'),
              onPressed: () async {
                const channel = MethodChannel('channel');
                await channel.invokeMethod<void>('method');
              },
            ),
            PlatformInfoWidget(),
          ],
        ),
      ),
    );
  }
}

class PlatformInfoWidget extends StatefulWidget {
  @override
  _PlatformInfoWidgetState createState() => _PlatformInfoWidgetState();
}

class _PlatformInfoWidgetState extends State<PlatformInfoWidget> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SentryFlutter.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> init() async {
    const platform = MethodChannel('io.sentry.flutter.manchestermaps/kmlLayer');
    try {
      final dynamic campusMapOverlay =
          await platform.invokeMethod<dynamic>('retrieveFileFromUrl');
      print(campusMapOverlay);
    } on PlatformException catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Running on: $_platformVersion\n'));
  }
}
