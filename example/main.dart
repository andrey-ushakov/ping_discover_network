/*
 * ping_discover_network
 * Created by Andrey Ushakov
 * 
 * See LICENSE for distribution and usage details.
 */
import 'package:ping_discover_network/ping_discover_network.dart';

void main() {
  final Stream<String> stream = NetworkAnalyzer.discover('192.168.0', 9100);

  stream.listen((String addr) {
    print('$addr');
  });
}
