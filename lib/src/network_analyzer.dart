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

  static Future<Socket> _ping(String host, int port) {
    return Socket.connect(
      host,
      port,
      timeout: Duration(seconds: 5),
    ).then((socket) {
      return socket;
    });
  }

  // TODO add duration
  static void discover(String subnet, int port) {
    // TODO : validate subnet & port

    final futures = <Future<Socket>>[];

    for (int i = 0; i < 256; ++i) {
      final host = '$subnet.$i';

      final Future<Socket> f = _ping(host, port);
      f.then((socket) {
        // TODO emit
        print('********** Found on $host');
        socket.destroy();
        socket.close();
      }).catchError((dynamic e) {});
      futures.add(f);
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
