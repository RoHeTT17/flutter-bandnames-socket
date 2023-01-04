import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:provider/provider.dart';

import 'package:band_names/services/socket_services.dart';

import 'package:band_names/models/band.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    //false, porque no necesitamos que se redibuje a este nivel. 
    final sockerService = Provider.of<SocketService>(context, listen: false); 
    
    //Aquí obtenemos el listados de las bands. Cuando se borra, aumentan los votos se escucha este evento y
    //redibuja por eso es que el provider esta en false.
    sockerService.getSocket.on('active-bands', _handleActiveBands);
  
  }

  _handleActiveBands(dynamic payload){
       //En tiempo de ejecución se sabe que es un List, por eso se castea.
       //Se recorre la lista y cada elemento lo transforma en una Band
       //toList para que retorne una lista al final, sino solo regresa un iterable.
       bands = (payload as List).map((banda) => Band.fromMap(banda)).toList();

       setState(() {
         
       });
  }

 @override
 void dispose() {
   
   final sockerService = Provider.of<SocketService>(context, listen: false); 
   sockerService.getSocket.off('active-bands');
   super.dispose();

 }


 List<Band> bands = [
                       /*Band(id: '01', name: 'Metalica', votes: 5),
                       Band(id: '02', name: 'Queen'   , votes: 1),
                       Band(id: '03', name: 'Enanitos', votes: 2),
                       Band(id: '04', name: 'Haragan' , votes: 5),*/
                    ];


  @override
  Widget build(BuildContext context) {
    
    final sockerService = Provider.of<SocketService>(context); 
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('BandNames', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: sockerService.getSeverStatus ==  ServerStatus.online
                      ? Icon(Icons.check, color: Colors.blue[300],)
                      : const Icon(Icons.offline_bolt, color: Colors.red,),
                    )
                 ],
        elevation: 1,
      ),
      body: Column(
        children: [
                    Expanded(
                      child: ListView.builder(
                                        itemCount: bands.length,
                                        itemBuilder: (BuildContext context, int index) {
                    
                                          return _banTile(bands[index]);
                                        },
                        ),
                    ),

                    Expanded(child: _ShowGraph(bands: bands,)),
                ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),                      
   );
  }

  Widget _banTile(Band band) {

    final socketService = Provider.of<SocketService>(context,listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        //print('direction: $direction');
        socketService.getSocket.emit('delete-band',{'id': band.id});
      },
      background: Container(
                            padding: const EdgeInsets.only(left: 8.0),
                            color: Colors.red[200],
                            child: const Align(
                                         alignment: Alignment.centerLeft,  
                                          child: Text('Delete Band', style: TextStyle(color: Colors.white),)
                                        ),
                           ),
      child: ListTile(
                       leading: CircleAvatar(backgroundColor: Colors.blue[100],child: Text(band.name.substring(0,2)),),
                       title: Text(band.name),
                       trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20),),
                       onTap: () {
                         //print(band.name);
                         socketService.getSocket.emit('vote-band', {'id' : band.id});
                       },
                    ),
    );
  }

  addNewBand(){

    final bandController = TextEditingController();
    
    if(Platform.isAndroid){  
        showDialog(
                  context: context, builder: ((context) {
                    return AlertDialog(
                      title: const Text('New band name'),
                      content: TextField( controller: bandController,),
                      actions: [
                                  MaterialButton(
                                                  elevation: 5,
                                                  textColor: Colors.blue,
                                                  onPressed: (() {
                                                    addBandToList(bandController.text);
                                                  }),
                                                  child:   const Text("Add") 
                                  )    
                              ],
                    );
                  })
                  );
    }else{

        showCupertinoDialog(
                      context: context, builder: ((context) {
                        return CupertinoAlertDialog(
                          title: const Text('New band name'),
                          content: TextField( controller: bandController,),
                          actions: [
                                      CupertinoDialogAction(
                                                      isDefaultAction: true,
                                                      onPressed: (() {
                                                        addBandToList(bandController.text);
                                                      }),
                                                      child:   const Text("Add") 
                                      ),
                                      CupertinoDialogAction(
                                                      isDestructiveAction: true,
                                                      onPressed: () => Navigator.of(context).pop,
                                                      child:   const Text("Dismiss") 
                                      )                                       
                                  ],
                        );
                      })
                      );
    }
  }

  void addBandToList(String name){

    final socketService = Provider.of<SocketService>(context, listen: false);

    if(name.isNotEmpty){
     
      socketService.getSocket.emit('add-band',{'name':name});
     
      /*setState(() {
        bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      });*/
    }

    Navigator.of(context).pop();

  }

}

class _ShowGraph extends StatelessWidget {
  
  final  List<Band> bands;
  
  const _ShowGraph({  Key? key, required this.bands, }) : super(key: key);

  @override
  Widget build(BuildContext context) {

  Map<String, double> dataMap = {
      /*"Flutter": 5,
      "React": 3,
      "Xamarin": 2,
      "Ionic": 2,*/
    };

    if(bands.isEmpty){
          dataMap.putIfAbsent('No data', ()=> 0.0);
    }else{

      for (var banda in bands) {
        
        dataMap.putIfAbsent(banda.name, ()=> banda.votes.toDouble());
      }
    }
    
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: PieChart(dataMap: dataMap)
      ) ;
  }
}