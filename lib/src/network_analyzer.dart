/*
 * ping_discover_network
 * Created by Andrey Ushakov
 * 
 * See LICENSE for distribution and usage details.
 */

import 'dart:async';
import 'dart:io';

/// [NetworkAnalyzer] class returns instances of [NetworkAddress].
///
/// Found ip addresses will have [exists] == true field.
class NetworkAddress {
  NetworkAddress(this.ip, this.exists);
  bool exists;
  String ip;
}

/// Pings a given subnet (xxx.xxx.xxx) on a given port using [discover] method.
class NetworkAnalyzer {
  /// Pings a given [subnet] (xxx.xxx.xxx) on a given [port].
  static Stream<NetworkAddress> discover(
    String subnet,
    int port, {
    Duration timeout = const Duration(milliseconds: 400),
  }) async* {
    if (port < 1 || port > 65535) {
      throw 'Incorrect port';
    }
    // TODO : validate subnet

    for (int i = 1; i < 256; ++i) {
      final host = '$subnet.$i';

      try {
        final Socket s = await Socket.connect(host, port, timeout: timeout);
        s.destroy();
        s.close();
        yield NetworkAddress(host, true);
      } catch (e) {
        if (!(e is SocketException)) {
          rethrow;
        }
        // 13: Connection failed (OS Error: Permission denied)
        // 49: Bind failed (OS Error: Can't assign requested address)
        // 61: OS Error: Connection refused
        // 64: Connection failed (OS Error: Host is down)
        // 65: No route to host
        // 101: Network is unreachable
        // 111: Connection refused
        // 113: No route to host
        // <empty>: SocketException: Connection timed out
        final errorCodes = [13, 49, 61, 64, 65, 101, 111, 113];

        // Check if connection timed out or we got one of predefined errors
        if (e.osError == null || errorCodes.contains(e.osError.errorCode)) {
          yield NetworkAddress(host, false);
        } else {
          // 23,24: Too many open files in system
          rethrow;
        }
      }
    }
  }
}
