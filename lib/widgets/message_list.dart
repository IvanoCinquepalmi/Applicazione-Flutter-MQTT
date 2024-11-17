import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  final List<String> messages;

  const MessageList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(
        child: Text('Nessun messaggio ricevuto.'),
      );
    }

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.message, color: Colors.blue),
          title: Text('Messaggio ${index + 1}'),
          subtitle: Text(messages[index]),
        );
      },
    );
  }
}
