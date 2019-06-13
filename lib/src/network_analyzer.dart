/*
 * ping_discover_network
 * Created by Andrey Ushakov
 * 
 * See LICENSE for distribution and usage details.
 */

import 'dart:io';

class NetworkAnalyzer {
  // NetworkAnalyzer(this.subnet);
  // final String subnet;

  static Future<Socket> _ping(String host, int port, Duration timeout) {
    return Socket.connect(host, port, timeout: timeout).then((socket) {
      return socket;
    });
  }

  static void discover(
    String subnet,
    int port, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    // TODO : validate subnet & port
    final futures = <Future<Socket>>[];

    for (int i = 0; i < 256; ++i) {
      final host = '$subnet.$i';

      final Future<Socket> f = _ping(host, port, timeout);
      futures.add(f);

      f.then((socket) {
        // TODO emit
        print('********** Found on $host');
        socket.destroy();
        socket.close();
      }).catchError((dynamic e) {});
    }

    Future.wait<Socket>(futures).then((sockets) {
      // TODO emit
      print('==> Finished');
    }).catchError((dynamic e) {
      // TODO emit
      print('==> Finished');
    });
  }
}
