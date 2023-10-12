import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BoletosRifaPage extends StatefulWidget {
  final String idDoc;
  const BoletosRifaPage({super.key, required this.idDoc});

  @override
  State<BoletosRifaPage> createState() => _BoletosRifaPageState();
}

class _BoletosRifaPageState extends State<BoletosRifaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Boletos Rifa"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore
            .instance
            .collection('boletos')
            .where('rifaId', isEqualTo: widget.idDoc)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          var boletos = snapshot.data!.docs;
          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot boleto = docs[index];
                return ListTile(
                  title: Text(boleto['numeroBoleto'].toString()),
                  subtitle: Text(boleto['reservado'].toString()),
                  onTap: (){
                    /*Navigator.push(context, MaterialPageRoute(builder:(context)=> AddRifa(idDoc: rifa.id))
                    );*/
                  },
                );
              });
        },
      ),
    );
  }
}
