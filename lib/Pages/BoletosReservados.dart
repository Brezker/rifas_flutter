import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Home.dart';

class BoletosReservadosPage extends StatefulWidget {
  final String idDoc;

  const BoletosReservadosPage({super.key, required this.idDoc });

  @override
  State<BoletosReservadosPage> createState() => _BoletosReservadosPageState();
}

class _BoletosReservadosPageState extends State<BoletosReservadosPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: AppBar(
        title: Text("Boletos Reservados"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('boletos').where('rifaId',isEqualTo: widget.idDoc).where('reservado',isEqualTo: true).snapshots(),
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
                  title: Text('Numero de boleto'+ boletos['numeroBoleto'].toString()),
                  subtitle: Text(boletos['reservado'].toString()),
                  onTap: (){
                    print('El valor de reservado en Rifas.dart es: $reservado');
                    /*Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          BuyTickets(idDoc: boletos.id,
                            ticketNumber: boletos ['numeroBoleto'], )),);*/
                  },
                );
              }
          );
        },
      ),
    );
  }
}
