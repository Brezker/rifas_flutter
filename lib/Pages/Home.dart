import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rifas/Pages/AddRifa.dart';
import 'package:rifas/Pages/Rifas.dart';
import 'package:rifas/Pages/SeleccionaRifa.dart';

bool reservado = false;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
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
            /*ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text("Rifas"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RifasPage()));
              },
            ),*/
            ListTile(
              leading: Icon(Icons.payment_sharp),
              title: Text("Boletos Apartados"),
              onTap: () {
                bool reservado = true;
                print('El valor de reservado en Rifas.dart es: $reservado');
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SeleccionaRifaPage()));
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore
            .instance
            .collection('rifas')
            .snapshots(),
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
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> AddRifa(idDoc: rifa.id))
                    );
                  },
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRifa(idDoc: '')),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
