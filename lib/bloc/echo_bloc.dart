/* External Dependencies */
import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

/* Local Dependencies */
import 'echo_event.dart';
import 'echo_state.dart';

class EchoBloc extends Bloc<EchoEvent, EchoState> {
  WebSocket? _webSocket;
  StreamSubscription? _subscription;

  EchoBloc() : super(EchoState([], false)) {
    on<ConnectEchoWebSocket>(_onConnect);

    on<SendEchoMessage>((event, emit) async {
      print('[BLoC] SendEchoMessage event: ${event.message}');
      if (_webSocket != null && state.connected) {
        _webSocket!.add(event.message);
        final updatedMessages = List<String>.from(state.messages)
          ..add('You: ${event.message}');
        emit(EchoState(updatedMessages, true));
        print('[BLoC] Message sent and state updated');
      } else {
        print('[BLoC] Cannot send, not connected');
      }
    });

    on<EchoMessageReceived>((event, emit) async {
      print('[BLoC] EchoMessageReceived event: ${event.message}');
      final updatedMessages = List<String>.from(state.messages)
        ..add('Echo: ${event.message}');
      emit(EchoState(updatedMessages, true));
      print('[BLoC] State updated with received message');
    });

    on<DisconnectEchoWebSocket>((event, emit) async {
      print('[BLoC] DisconnectEchoWebSocket event');
      await _subscription?.cancel();
      await _webSocket?.close();
      emit(EchoState(state.messages, false));
      print('[BLoC] Disconnected and state updated');
    });
  }

  Future<void> _onConnect(
      ConnectEchoWebSocket event, Emitter<EchoState> emit) async {
    print('[BLoC] ConnectEchoWebSocket event');
    try {
      _webSocket = await WebSocket.connect('wss://ws.postman-echo.com/raw');
      emit(EchoState(state.messages, true));
      print('[BLoC] WebSocket connected');
      _subscription = _webSocket!.listen((data) {
        print('[BLoC] Data received from WebSocket: $data');
        add(EchoMessageReceived(data));
      }, onDone: () {
        print('[BLoC] WebSocket connection closed (onDone)');
        add(DisconnectEchoWebSocket());
      }, onError: (e) {
        print('[BLoC] WebSocket error: $e');
        add(DisconnectEchoWebSocket());
      });
      print('[BLoC] WebSocket subscription created and listening');
    } catch (e) {
      print('[BLoC] WebSocket connection failed: $e');
      emit(EchoState(state.messages, false));
    }
  }

  @override
  Future<void> close() {
    print('[BLoC] Closing EchoBloc and cleaning up WebSocket...');
    _subscription?.cancel();
    _webSocket?.close();
    return super.close();
  }
}
