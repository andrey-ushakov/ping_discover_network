/*
 * ping_discover_network
 * Created by Andrey Ushakov
 * 
 * See LICENSE for distribution and usage details.
 */

import 'package:ping_discover_network/ping_discover_network.dart';

void main() {
  NetworkAnalyzer.discover('192.168.0', 9100);
}
