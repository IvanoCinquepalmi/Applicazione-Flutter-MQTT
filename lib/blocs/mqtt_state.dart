import 'package:equatable/equatable.dart';

abstract class MqttState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MqttInitial extends MqttState {}

class MqttConnecting extends MqttState {}

class MqttConnected extends MqttState {}

class MqttDisconnected extends MqttState {}

class MqttError extends MqttState {
  final String error;

  MqttError(this.error);

  @override
  List<Object?> get props => [error];
}

class MqttMessageReceived extends MqttState {
  final List<String> messages;
  MqttMessageReceived(this.messages);

  @override
  List<Object?> get props => [messages];
}
