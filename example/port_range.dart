/*
 * ping_discover_network
 * Created by Andrey Ushakov
 * 
 * See LICENSE for distribution and usage details.
 */
import 'package:ping_discover_network/ping_discover_network.dart';

void checkPortRange(String subnet, int fromPort, int toPort) {
  if (fromPort > toPort) {
    return;
  }

  print('port $fromPort');
  final stream = NetworkAnalyzer.discover(subnet, fromPort);

  stream.listen((NetworkAddress addr) {
    if (addr.exists) {
      print('Found device: ${addr.ip}:$fromPort');
    }
  }).onDone(() {
    checkPortRange(subnet, fromPort + 1, toPort);
  });
}

/// Discover available network devices in a given subnet on a given port range
void main() {
  checkPortRange('192.168.0', 80, 88);
}
