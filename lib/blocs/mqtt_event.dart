import 'package:equatable/equatable.dart';
import '../models/mqtt_credentials.dart';

abstract class MqttEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConnectMqtt extends MqttEvent {
  final MqttCredentials credentials;

  ConnectMqtt(this.credentials);

  @override
  List<Object?> get props => [credentials];
}

class DisconnectMqtt extends MqttEvent {}

class MessageReceived extends MqttEvent {
  final String message;

  MessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}
