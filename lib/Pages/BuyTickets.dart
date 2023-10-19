import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuyTickets extends StatefulWidget {
  final String idDoc;
  final int ticketNumber;
  BuyTickets({required this.idDoc, required this.ticketNumber});

  @override
  _BuyTicketsState createState() => _BuyTicketsState();
}


class _BuyTicketsState extends State<BuyTickets> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();


  void _updateDocument() async{
    await FirebaseFirestore.instance.collection('boletos').doc(widget.idDoc).set({
      'comprador' : nombreController.text,
      'telefono_comprador' : telefonoController.text,
      'reservado' : true,
    }, SetOptions(merge: true),);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

        appBar: AppBar(
          title: Text("Venta de controller"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: telefonoController,
                decoration: InputDecoration(labelText: 'Numero Telefonico'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              TextButton(onPressed: _updateDocument, child: Text('Guardar'))
            ],
          ),
        )
    );
  }
}