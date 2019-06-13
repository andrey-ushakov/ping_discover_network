/*
 * ping_discover_network
 * Created by Andrey Ushakov
 * 
 * See LICENSE for distribution and usage details.
 */

import 'dart:async';
import 'dart:io';

///
class NetworkAddress {
  NetworkAddress(this.ip, this.exists);
  bool exists;
  String ip;
}

///
class NetworkAnalyzer {
  static Future<Socket> _ping(String host, int port, Duration timeout) {
    return Socket.connect(host, port, timeout: timeout).then((socket) {
      return socket;
    });
  }

  static Stream<NetworkAddress> discover(
    String subnet,
    int port, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    final out = StreamController<NetworkAddress>();
    // TODO : validate subnet & port
    final futures = <Future<Socket>>[];

    for (int i = 0; i < 256; ++i) {
      final host = '$subnet.$i';
      final Future<Socket> f = _ping(host, port, timeout);
      futures.add(f);

      f.then((socket) {
        socket.destroy();
        socket.close();
        out.sink.add(NetworkAddress(host, true));
      }).catchError((dynamic e) {
        out.sink.add(NetworkAddress(host, false));
      });
    }

    Future.wait<Socket>(futures)
        .then<void>((sockets) => out.close())
        .catchError((dynamic e) => out.close());

    return out.stream;
  }
}
