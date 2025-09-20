/* External Dependencies */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* Local Dependencies */
import 'bloc/echo_bloc.dart';
import 'bloc/echo_event.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const EchoWebSocketApp());
}

class EchoWebSocketApp extends StatelessWidget {
  const EchoWebSocketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EchoBloc()..add(ConnectEchoWebSocket()),
      child: MaterialApp(
        title: 'Echo WebSocket',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      ),
    );
  }
}
