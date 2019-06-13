/*
 * ping_discover_network
 * Created by Andrey Ushakov
 * 
 * See LICENSE for distribution and usage details.
 */
import 'package:ping_discover_network/ping_discover_network.dart';

void main() {
  final stream = NetworkAnalyzer.discover('192.168.0', 80);

  stream.listen((NetworkAddress addr) {
    if (addr.exists) {
      print('Found device: ${addr.ip}');
    }
  }).onDone(() => print('Finish'));
}
