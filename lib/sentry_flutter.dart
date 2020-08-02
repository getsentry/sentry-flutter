import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:sentry/sentry.dart';

mixin SentryFlutter {
  static const _channel = MethodChannel('sentry_flutter');
  static SentryClient _sentry;
  static SentryOptions _options;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> init(void Function(SentryOptions o) options,
      StatelessWidget Function() app) async {
    final opt = SentryOptions();
    options(opt);

    if (opt.dsn == null) {
      print('No dsn provided, Sentry SDK will be disabled.');
      return;
    }
    _options = opt;
    _sentry = SentryClient(dsn: opt.dsn);

    bool inDebugMode = false;
    assert(inDebugMode = true);
    if (!inDebugMode || opt.captureWithDebuggerAttached) {
      final originalOnErrorCallback = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) async {
        // TODO: Explore 'details'
        Zone.current.handleUncaughtError(details.exception, details.stack);
        originalOnErrorCallback(details);
      };
    } else {
      if (opt.debug) {
        print(
            'SDK Disabled because debugger attached and captureWhenDebuggerAttached=false');
      }
    }

    runZonedGuarded<Future<void>>(() async {
      runApp(app());
      // runApp(SentryWidget(app()));
    }, (e, s) async {
      print('captureException');
      // await Sentry.captureException(e, s);
      _sentry.captureException(exception: e, stackTrace: s);
    }, zoneSpecification:
        ZoneSpecification(print: (self, parent, zone, message) {
      // TODO: Add breadcrumb
      if (_options.debug) {
        print('Zone debug(todo) breadrumb: ' + message);
      }
      parent.print(zone, message);
    }));
  }

  static Future<void> captureMessage(String message) async {
    await _sentry.capture(
        event: Event(
            message: message,
            // TODO: Remove current frame
            stackTrace: _options.attachStacktrace ? StackTrace.current : null,
            level: SeverityLevel.info));
  }
}

class SentryOptions {
  // Enable SDK debug mode
  bool debug = false;
  // TODO: Usually incurs overhead and is false by default
  bool attachStacktrace = true;
  // Whether or not Sentry should capture events when the debugger is attached
  bool captureWithDebuggerAttached = true;
  String dsn;
}
