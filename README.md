# ping_discover_network

Dart/Flutter library that allows to ping IP subnet and therefore dicover network devices.

Could be used to find printers, for example, on port 9100 and other services.

## Getting Started

Discover available network devices in a given subnet on a given port

```dart
import 'package:ping_discover_network/ping_discover_network.dart';

final stream = NetworkAnalyzer.discover('192.168.0', 9100);

  stream.listen((NetworkAddress addr) {
    if (addr.exists) {
      print('Found device: ${addr.ip}');
    }
  }).onDone(() => print('Finish'));
```

Discover available network devices in a given subnet on a given port range

```dart
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
    if (fromPort + 1 <= toPort) {
      checkPortRange(subnet, fromPort + 1, toPort);
    }
  });
}

checkPortRange('192.168.0', 400, 410);
```
