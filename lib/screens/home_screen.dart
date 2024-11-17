import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/mqtt_bloc.dart';
import '../blocs/mqtt_state.dart';
import '../widgets/message_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messaggi MQTT')),
      body: BlocBuilder<MqttBloc, MqttState>(
        builder: (context, state) {
          if (state is MqttConnecting) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MqttError) {
            return Center(
              child: Text('Errore: ${state.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          } else if (state is MqttMessageReceived) {
            // Utilizzo della classe MessageList per mostrare i messaggi
            return MessageList(messages: state.messages);
          }
          return const Center(child: Text('In attesa di messaggi...'));
        },
      ),
    );
  }
}
