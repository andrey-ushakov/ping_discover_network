/*
 * ping_discover_network
 * Created by Andrey Ushakov
 * 
 * See LICENSE for distribution and usage details.
 */
import 'package:ping_discover_network/ping_discover_network.dart';

/// Discover available network devices in a given subnet on a given port
void main() {
  const port = 80;
  final stream = NetworkAnalyzer.discover('192.168.0', port);

  int found = 0;
  stream.listen((NetworkAddress addr) {
    if (addr.exists) {
      found++;
      print('Found device: ${addr.ip}:$port');
    }
  }).onDone(() => print('Finish. Found $found device(s)'));
}
