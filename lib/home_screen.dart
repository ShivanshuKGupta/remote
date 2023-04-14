import 'package:flutter/material.dart';
import 'package:remote/server_tools.dart';

class HomeScreen extends StatefulWidget {
  Image? img;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Server server = Server();
  TextEditingController serverAddr = TextEditingController();
  bool _showImage = true;

  _HomeScreenState() {
    serverAddr.text = '192.168.10.126';
  }

  void bttn(String msg) {
    {
      server.send('$msg,');
      // server.receiveString();
      server.receiveImage();
      if (_showImage) {
        setState(() {
          widget.img = server.image;
        });
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
        children: [
          if (widget.img != null && _showImage)
            InteractiveViewer(child: widget.img!),
          TextField(
            controller: serverAddr,
            decoration:
                const InputDecoration(label: Text('Enter Server Address')),
          ),
          Text(server.socket != null ? 'Connected' : 'Not Connected'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    child: const Text('Connect'),
                    onPressed: () {
                      setState(() {
                        server.connect(serverAddr.text);
                      });
                    }),
                ElevatedButton(
                    child: const Text('Disconnect'),
                    onPressed: () {
                      setState(() {
                        server.disconnect();
                      });
                    }),
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
