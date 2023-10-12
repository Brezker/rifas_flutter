import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rifas/Pages/BoletosRifa.dart';

class RifasPage extends StatefulWidget {
  const RifasPage({super.key});

  @override
  State<RifasPage> createState() => _RifasPageState();
}

class _RifasPageState extends State<RifasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rifas"),
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
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> BoletosRifaPage(idDoc: rifa.id))
                    );
                  },
                );
              });
        },
      ),
    );
  }
}
