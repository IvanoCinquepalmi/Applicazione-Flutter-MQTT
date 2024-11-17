import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/mqtt_bloc.dart';
import 'screens/connect_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MqttBloc>(
          create: (context) => MqttBloc(),
        ),
      ],
      child: const MaterialApp(
        title: 'MQTT App',
        home: ConnectScreen(),
      ),
    );
  }
}
