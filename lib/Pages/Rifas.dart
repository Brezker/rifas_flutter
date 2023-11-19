import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rifas/Pages/BoletosRifa.dart';
import 'package:rifas/Pages/Login.dart';

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

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                          'https://cdn-icons-png.flaticon.com/512/1144/1144760.png'),
                    ),
                    Text("Usuario")
                  ],
                )),
            ListTile(
              leading: Icon(Icons.person_2),
              title: Text("Identificate"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
              },
            ),
          ],
        ),
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
                  leading: Image.network(rifa['imagenUrl']),
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
