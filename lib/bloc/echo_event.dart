abstract class EchoEvent {}

class ConnectEchoWebSocket extends EchoEvent {}

class DisconnectEchoWebSocket extends EchoEvent {}

class SendEchoMessage extends EchoEvent {
  final String message;
  SendEchoMessage(this.message);
}

class EchoMessageReceived extends EchoEvent {
  final String message;
  EchoMessageReceived(this.message);
}
