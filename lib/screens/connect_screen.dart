import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/mqtt_bloc.dart';
import '../blocs/mqtt_event.dart';
import '../models/mqtt_credentials.dart';
import 'home_screen.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final _brokerController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _topicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connessione MQTT')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _brokerController,
                decoration: const InputDecoration(labelText: 'Broker')),
            TextField(
                controller: _portController,
                decoration: const InputDecoration(labelText: 'Porta'),
                keyboardType: TextInputType.number),
            TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username')),
            TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true),
            TextField(
                controller: _topicController,
                decoration: const InputDecoration(labelText: 'Topic')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final creds = MqttCredentials(
                  broker: _brokerController.text,
                  port: int.parse(_portController.text),
                  username: _usernameController.text,
                  password: _passwordController.text,
                  topic: _topicController.text,
                );
                context.read<MqttBloc>().add(ConnectMqtt(creds));
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()));
              },
              child: const Text('Connetti'),
            ),
          ],
        ),
      ),
    );
  }
}
