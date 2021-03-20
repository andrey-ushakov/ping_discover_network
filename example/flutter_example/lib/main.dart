import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String localIp = '';
  List<String> devices = [];
  bool isDiscovering = false;
  int found = -1;
  TextEditingController portController = TextEditingController(text: '80');

  void discover(BuildContext ctx) async {
    setState(() {
      isDiscovering = true;
      devices.clear();
      found = -1;
    });

    String ip;
    try {
      ip = await _getLocalIpAddress();
      print('local ip:\t$ip');
    } catch (e) {
      final snackBar = SnackBar(content: Text('WiFi is not connected', textAlign: TextAlign.center));
      ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
      return;
    }
    setState(() {
      localIp = ip;
    });

    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    int port = 80;
    try {
      port = int.parse(portController.text);
    } catch (e) {
      portController.text = port.toString();
    }
    print('subnet:\t$subnet, port:\t$port');

    final stream = NetworkAnalyzer.discover(subnet, port);

    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        print('Found device: ${addr.ip}');
        setState(() {
          devices.add(addr.ip);
          found = devices.length;
        });
      }
    })
      ..onDone(() {
        setState(() {
          isDiscovering = false;
          found = devices.length;
        });
      })
      ..onError((dynamic e) {
        final snackBar = SnackBar(content: Text('Unexpected exception', textAlign: TextAlign.center));
        ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
      });
  }

  // https://stackoverflow.com/questions/63514434/flutter-get-local-ip-address-on-android
  Future<String> _getLocalIpAddress() async {
    final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4, includeLinkLocal: true);

    try {
      // Try VPN connection first
      final vpnInterface = interfaces.firstWhere((element) => element.name == 'tun0');
      return vpnInterface.addresses.first.address;
    } on StateError {
      // Try wlan connection next
      try {
        final interface = interfaces.firstWhere((element) => element.name == 'wlan0');
        return interface.addresses.first.address;
      } catch (ex) {
        // Try any other connection next
        try {
          final interface = interfaces.firstWhere((element) => !(element.name == 'tun0' || element.name == 'wlan0'));
          return interface.addresses.first.address;
        } catch (ex) {
          return '';
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Local Network'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: portController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Port',
                    hintText: 'Port',
                  ),
                ),
                SizedBox(height: 10),
                Text('Local ip: $localIp', style: TextStyle(fontSize: 16)),
                SizedBox(height: 15),
                ElevatedButton(child: Text('${isDiscovering ? 'Discovering...' : 'Discover'}'), onPressed: isDiscovering ? null : () => discover(context)),
                SizedBox(height: 15),
                found >= 0 ? Text('Found: $found device(s)', style: TextStyle(fontSize: 16)) : Container(),
                Expanded(
                  child: ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            height: 60,
                            padding: EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.devices),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${devices[index]}:${portController.text}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
