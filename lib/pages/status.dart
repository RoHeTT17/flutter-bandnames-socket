import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/services/socket_services.dart';


class StatusPage extends StatelessWidget {
  const StatusPage({super.key});


  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                      Text('ServerStatus: ${socketService.getSeverStatus}' )
                    ],
        )
     ),
     floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.message),
      onPressed: () {  
        socketService.getSocket.emit('emitir-mensaje',{'nombre':'flutter', 'mensaje': 'hola- desde flutter'});
      },

     ),
   );
  }
}