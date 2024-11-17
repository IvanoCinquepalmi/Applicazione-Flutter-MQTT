class MqttCredentials {
  final String broker;
  final int port;
  final String username;
  final String password;
  final String topic;

  MqttCredentials({
    required this.broker,
    required this.port,
    required this.username,
    required this.password,
    required this.topic,
  });
}
