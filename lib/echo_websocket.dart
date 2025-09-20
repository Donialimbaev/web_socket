/* External Dependencies */
import 'dart:async';
import 'dart:io';

class EchoWebSocket {
  WebSocket? _webSocket;
  StreamController<String> _controller = StreamController.broadcast();

  Stream<String> get messages => _controller.stream;

  Future<void> connect() async {
    _webSocket = await WebSocket.connect('wss://ws.postman-echo.com/raw');
    _webSocket!.listen((data) {
      _controller.add(data);
    }, onDone: () {
      _controller.add('Connection closed');
    }, onError: (e) {
      _controller.add('Error: ' + e.toString());
    });
  }

  void send(String message) {
    _webSocket?.add(message);
  }

  Future<void> disconnect() async {
    await _webSocket?.close();
    await _controller.close();
  }
}
