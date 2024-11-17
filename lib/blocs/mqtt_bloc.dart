import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';
import 'mqtt_event.dart';
import 'mqtt_state.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  MqttServerClient? _client;
  List<String> _messages = [];

  MqttBloc() : super(MqttInitial()) {
    on<ConnectMqtt>(_connectToBroker);
    on<SubscribeTopic>(_subscribeToTopic);
    on<MessageReceived>(_onMessageReceived);
  }

  Future<void> _connectToBroker(ConnectMqtt event, Emitter<MqttState> emit) async {
    emit(MqttConnecting());

    final creds = event.credentials;
    _client = MqttServerClient(creds.broker, 'flutter_client');
    _client!.port = creds.port;
    _client!.logging(on: true);
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = () {
      emit(MqttError('Client disconnesso.'));
    };

    try {
      // Verifica se username e password sono vuoti
      if (creds.username.isEmpty && creds.password.isEmpty) {
        await _client!.connect(); // Connessione senza autenticazione per broker pubblici
      } else {
        await _client!.connect(creds.username, creds.password); // Connessione con autenticazione
      }

      // Verifica se la connessione è riuscita
      if (_client!.connectionStatus!.state == mqtt.MqttConnectionState.connected) {
        emit(MqttConnected());
        // Sottoscrivi al topic dopo la connessione
        _client!.subscribe(creds.topic, mqtt.MqttQos.atMostOnce);

        // Ascolta i messaggi
        _client!.updates?.listen((List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>>? c) {
          final recMess = c![0].payload as mqtt.MqttPublishMessage;
          final message =
          mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          add(MessageReceived(message));
        });
      } else {
        emit(MqttError('Connessione fallita: ${_client!.connectionStatus!.returnCode}'));
      }
    } catch (e) {
      emit(MqttError('Connessione fallita: $e'));
      _client?.disconnect();
    }
  }


  void _subscribeToTopic(SubscribeTopic event, Emitter<MqttState> emit) {
    if (_client?.connectionStatus?.state == mqtt.MqttConnectionState.connected) {
      _client!.subscribe(event.topic, mqtt.MqttQos.atMostOnce);

      _client!.updates!.listen((List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>>? c) {
        final recMess = c![0].payload as mqtt.MqttPublishMessage;
        final message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        add(MessageReceived(message));
      });

      emit(MqttConnected());
    } else {
      emit(MqttError('Il client non è connesso.'));
    }
  }

  void _onMessageReceived(MessageReceived event, Emitter<MqttState> emit) {
    _messages.add(event.message);
    emit(MqttMessageReceived(List.from(_messages))); // Usa una copia della lista
  }
}
