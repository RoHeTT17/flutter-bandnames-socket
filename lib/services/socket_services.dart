import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting
}


class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get getSeverStatus => _serverStatus;
  IO.Socket get getSocket => _socket;

  SocketService(){
      _initConfig();
  }

  void _initConfig(){
    
    // Dart client
    _socket = IO.io('http://172.16.2.46:3001/',{
      'transports' : ['websocket'], //Define el tipo de comunicación con el server
      'autoConnect': true // para que se conecte de forma automatica. Si fuera false, se usuaría el comando sockect.onConnect()
    });

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload) {
    //   //print('******nuevo-mensaje*****: $payload');
    //   print('Cliente: '+ payload['cliente'] ?? 'No definido');
    //   print('Mensaje: '+ payload['mensaje'] ?? 'No definido');
    // });


  }

}