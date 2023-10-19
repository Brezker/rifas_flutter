//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rifas/Pages/BuyTickets.dart';

class BoletosRifaPage extends StatefulWidget {
  final String idDoc;

  const BoletosRifaPage({super.key, required this.idDoc });

  @override
  State<BoletosRifaPage> createState() => _BoletosRifaPageState();
}

class _BoletosRifaPageState extends State<BoletosRifaPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: AppBar(
        title: Text("Boletos de la Rifa"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('boletos').where('rifaId',isEqualTo: widget.idDoc).where('reservado',isEqualTo: false).snapshots(),
        builder: (context,  snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          List<DocumentSnapshot> docs = snapshot.data!.docs;

          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index){
                final DocumentSnapshot boletos = docs[index];
                return ListTile(
                  leading: const Icon(Icons.shopping_bag),
                  title: Text('Numero de boleto '+ boletos['numeroBoleto'].toString()),
                  subtitle: Text(boletos['reservado'].toString()),
                  onTap: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          BuyTickets(idDoc: boletos.id,
                            ticketNumber: boletos ['numeroBoleto'], )),);
                  },
                );
              }
          );
        },
      ),
    );
  }
}
