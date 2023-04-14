import 'package:flutter/material.dart';
import 'package:remote/server_tools.dart';

void Function()? refresh;

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Server server = Server();
  TextEditingController serverAddr = TextEditingController();
  bool _showImage = true;

  _HomeScreenState() {
    serverAddr.text = '192.168.10.126';
    refresh = _setState;
  }

  void _setState() {
    setState(() {});
  }

  void bttn(String msg) {
    {
      server.send('$msg,');
      // server.receiveString();
      server.receiveImage();
      if (_showImage) {
        server.image;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Remote'),
        actions: [
          Switch(
              value: _showImage,
              onChanged: (value) {
                setState(() {
                  _showImage = value;
                });
              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (server.image != null && _showImage)
            Expanded(child: InteractiveViewer(child: server.image!)),
          TextField(
            controller: serverAddr,
            decoration:
                const InputDecoration(label: Text('Enter Server Address')),
          ),
          // Text(server.socket != null ? 'Connected' : 'Not Connected'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: server.socket != null
                        ? null
                        : () {
                            server.connect(serverAddr.text);
                          },
                    child: const Text('Connect')),
                ElevatedButton(
                    onPressed: server.socket == null
                        ? null
                        : () {
                            server.disconnect();
                          },
                    child: const Text('Disconnect')),
              ],
            ),
          ),
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () => bttn('up'),
                    icon: const Icon(Icons.arrow_drop_up),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () => bttn('left'),
                        icon: const Icon(Icons.arrow_left),
                      ),
                      IconButton(
                        onPressed: () => bttn('right'),
                        icon: const Icon(Icons.arrow_right),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => bttn('down'),
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
