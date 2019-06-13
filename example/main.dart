/*
 * ping_discover_network
 * Created by Andrey Ushakov
 * 
 * See LICENSE for distribution and usage details.
 */
import 'dart:async';
import 'package:ping_discover_network/ping_discover_network.dart';

void main() {
  print('*** main start ***');
  final Stream<String> stream = NetworkAnalyzer.discover('192.168.0', 9100);

  stream.listen((String addr) {
    print('$addr');
  });

  print('*** main end ***');
}
