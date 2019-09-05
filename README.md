# ping_discover_network

![Pub](https://img.shields.io/pub/v/ping_discover_network.svg)

[Dart](https://dart.dev)/[Flutter](https://flutter.dev) library that allows to ping IP subnet and discover network devices.

Could be used to find printers (for example, on port 9100) and any other devices and services in local network.

The device should be connected to a Wi-Fi network. [wifi package](https://pub.dev/packages/wifi) allows to get the local IP address / network subnet. 

The library tested on both, Android and iOS platforms.

[[pub.dev page]](https://pub.dev/packages/ping_discover_network) | [[Documentation]](https://pub.dev/documentation/ping_discover_network/latest/)

## Getting Started

*Check complete examples in /example folder.*

Discover available network devices in a given subnet on a given port:

```dart
import 'package:ping_discover_network/ping_discover_network.dart';

// NetworkAnalyzer.discover pings PORT:IP one by one according to timeout.
// NetworkAnalyzer.discover2 pings all PORT:IP addresses at once.

const port = 80;
final stream = NetworkAnalyzer.discover2(
  '192.168.0', port,
  timeout: Duration(milliseconds: 5000),
);

int found = 0;
stream.listen((NetworkAddress addr) {
  if (addr.exists) {
    found++;
    print('Found device: ${addr.ip}:$port');
  }
}).onDone(() => print('Finish. Found $found device(s)'));
```

Get local ip and discover network devices:
```dart
import 'package:wifi/wifi.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

final String ip = await Wifi.ip;
final String subnet = ip.substring(0, ip.lastIndexOf('.'));
final int port = 80;

final stream = NetworkAnalyzer.discover2(subnet, port);
stream.listen((NetworkAddress addr) {
  if (addr.exists) {
    print('Found device: ${addr.ip}');
  }
});
```

Discover available network devices in a given subnet on a given port range:

```dart
import 'package:ping_discover_network/ping_discover_network.dart';

void checkPortRange(String subnet, int fromPort, int toPort) {
  if (fromPort > toPort) {
    return;
  }

  print('port ${fromPort}');

  final stream = NetworkAnalyzer.discover2(subnet, fromPort);

  stream.listen((NetworkAddress addr) {
    if (addr.exists) {
      print('Found device: ${addr.ip}:${fromPort}');
    }
  }).onDone(() {
    checkPortRange(subnet, fromPort + 1, toPort);
  });
}

checkPortRange('192.168.0', 400, 410);
```
