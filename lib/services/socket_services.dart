import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting
}


class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.connecting;

  SocketService(){
      _initConfig();
  }

  void _initConfig(){
    
    // Dart client
    IO.Socket socket = IO.io('http://localhost:3001/');

    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    
    socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));


  }

}