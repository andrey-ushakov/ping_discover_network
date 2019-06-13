/*
 * ping_discover_network
 * Created by Andrey Ushakov
 * 
 * See LICENSE for distribution and usage details.
 */

import 'dart:async';
import 'dart:io';

class NetworkAnalyzer {
  static Future<Socket> _ping(String host, int port, Duration timeout) {
    return Socket.connect(host, port, timeout: timeout).then((socket) {
      return socket;
    });
  }

  static Stream<String> discover(
    String subnet,
    int port, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    final out = StreamController<String>();
    // TODO : validate subnet & port
    final futures = <Future<Socket>>[];

    for (int i = 0; i < 256; ++i) {
      final host = '$subnet.$i';
      final Future<Socket> f = _ping(host, port, timeout);
      futures.add(f);

      f.then((socket) {
        socket.destroy();
        socket.close();
        out.sink.add('!!!!!!!!!!!!!!!!!!!!!!!!!! $host');
      }).catchError((dynamic e) {
        out.sink.add('$host');
      });
    }

    Future.wait<Socket>(futures)
        .then((sockets) => out.sink.add('==> Finished'))
        .catchError((dynamic e) => out.sink.add('==> Finished'));

    return out.stream;
  }
}
