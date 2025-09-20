/* External Dependencies */
import 'package:flutter/material.dart';

/* Local Dependencies */
import '../echo_websocket.dart';

class EchoScreen extends StatefulWidget {
  @override
  _EchoScreenState createState() => _EchoScreenState();
}

class _EchoScreenState extends State<EchoScreen> {
  final EchoWebSocket _echoWebSocket = EchoWebSocket();
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _echoWebSocket.connect().then((_) {
      setState(() {
        _connected = true;
      });
      _echoWebSocket.messages.listen((msg) {
        setState(() {
          _messages.add(msg);
        });
      });
    });
  }

  @override
  void dispose() {
    _echoWebSocket.disconnect();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty && _connected) {
      _echoWebSocket.send(_controller.text);
      setState(() {
        _messages.add('You: ' + _controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Echo WebSocket')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_messages[index]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
