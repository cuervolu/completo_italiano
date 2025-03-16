import 'dart:io' as io;
import 'package:logger/logger.dart';

Logger get logger => Log.instance;

class Log extends Logger {
  Log._()
    : super(
        printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: io.stdout.hasTerminal ? io.stdout.terminalColumns : 80,
          colors: io.stdout.supportsAnsiEscapes,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
      );
  static final instance = Log._();
}
