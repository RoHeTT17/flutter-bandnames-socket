import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/band.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 
 List<Band> bands = [
                       Band(id: '01', name: 'Metalica', votes: 5),
                       Band(id: '02', name: 'Queen'   , votes: 1),
                       Band(id: '03', name: 'Enanitos', votes: 2),
                       Band(id: '04', name: 'Haragan' , votes: 5),
                    ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('BandNames', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
                               itemCount: bands.length,
                               itemBuilder: (BuildContext context, int index) {

                                  return _banTile(bands[index]);
                               },
                            ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),                      
   );
  }

  Widget _banTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direction: $direction');
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
                         print(band.name);
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

    if(name.isNotEmpty){
      setState(() {
        bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      });
    }

    Navigator.of(context).pop();

  }

}