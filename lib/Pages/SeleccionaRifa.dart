import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rifas/Pages/AddRifa.dart';
import 'package:rifas/Pages/BoletosReservados.dart';
import 'package:rifas/Pages/BoletosRifa.dart';

class SeleccionaRifaPage extends StatefulWidget {
  const SeleccionaRifaPage({super.key});

  @override
  State<SeleccionaRifaPage> createState() => _SeleccionaRifaPageState();
}

class _SeleccionaRifaPageState extends State<SeleccionaRifaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecciona Rifa"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('rifas').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot rifa = docs[index];
                return ListTile(
                  title: Text(rifa['nombre']),
                  subtitle: Text(rifa['descripcion']),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> BoletosReservadosPage(idDoc: rifa.id))
                    );
                  },
                );
              });
        },
      ),

    );
  }
}
