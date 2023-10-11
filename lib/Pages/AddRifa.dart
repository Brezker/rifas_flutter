import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rifas/Pages/Home.dart';

class AddRifa extends StatefulWidget {
  final String idDoc;

  const AddRifa({super.key, required this.idDoc});

  @override
  State<AddRifa> createState() => _AddRifaState(this.idDoc);
}

class RifaDeleter {
  static Future<void> eliminarRifa(String idDoc) async {
    if (idDoc.isNotEmpty) {
      await FirebaseFirestore.instance.collection('rifas').doc(idDoc).delete();
    }
  }
}

class _AddRifaState extends State<AddRifa> {
  final _form = GlobalKey<FormState>();
  final String idDoc;

  CollectionReference
  rifas= FirebaseFirestore.instance.collection('rifas');

  DateTime? startDate;
  DateTime? endDate;
  TextEditingController nombreController= TextEditingController();
  TextEditingController descripcionController= TextEditingController();
  TextEditingController numeroBoletosController= TextEditingController();
  TextEditingController precioBoletosController= TextEditingController();

  TextEditingController fechaIController= TextEditingController(text: DateTime.now().toString());
  TextEditingController fechaFController= TextEditingController(text: DateTime.now().toString());

  _AddRifaState(this.idDoc) {
    print("Valor de idDoc: $idDoc");
    if (idDoc.isNotEmpty) {
      rifas.doc(idDoc).get().then((value) {
        nombreController.text = value['nombre'];
        descripcionController.text = value['descripcion'];
        numeroBoletosController.text = value['numeroBoletos'].toString();
        precioBoletosController.text = value['precioBoletos'].toString();
        startDate= value['fechaInicio'].toDate();
        endDate= value['fechaFin'].toDate();

        fechaFController.text=startDate.toString();
        fechaIController.text=endDate.toString();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar nueva rifa"),
      ),
      body: Form(
        key: _form,
        child: Column(
          // decoration: BoxDecoration(gradient: LinearGradient(colors: )),
          children: [

            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: nombreController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Nombre Rifa"),
                  validator: (value) {
                    if (value == "") {
                      return "este campo es obligatorio";
                    }
                    return null;
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                  controller: descripcionController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Descripción"),
                    validator: (value) {
                      if (value == "") {
                        return "este campo es obligatorio";
                      }
                      return null;
                    }),
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: numeroBoletosController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Número de boletos"
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (value == "") {
                    return "Este campo es obligatorio";
                  }
                  return null;
                },
                keyboardType: TextInputType.number, // Esto también ayuda a mostrar un teclado numérico.
              ),
            ),


            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: precioBoletosController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Precio"
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
                ],
                validator: (value) {
                  if (value == "") {
                    return "Este campo es obligatorio";
                  }
                  return null;
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),

            DateTimePicker(
              type: DateTimePickerType.date,
              dateMask: 'd MMM, yyyy',
              //initialValue: DateTime.now().toString(),
              controller: fechaIController,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
              icon: Icon(Icons.event),
              dateLabelText: 'Fecha de inicio',
              onChanged: (val) {
                setState(() {
                  startDate = DateTime.parse(val);
                });
              },
            ),

            DateTimePicker(
              type: DateTimePickerType.date,
              dateMask: 'd MMM, yyyy',
              //initialValue: DateTime.now().toString(),
              controller: fechaFController,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
              icon: Icon(Icons.event),
              dateLabelText: 'Fecha de fin',
              onChanged: (val) {
                setState(() {
                  endDate = DateTime.parse(val);
                });
              },
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextButton.icon(
                onPressed: () async {
                  await _performDeletion();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                label: Text(
                  "Eliminar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )


          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
      onPressed: ()async{

        print("Valor de idDoc al guardar/editar: $idDoc");
        var isValid = _form.currentState?.validate();
        if (isValid == null || !isValid) {
          //print("holaaaaa"+idDoc);
          return;

        }
        Map<String, dynamic> rifaData={
          'nombre':nombreController.text,
          'descripcion': descripcionController.text,
          'numeroBoletos':int.tryParse(numeroBoletosController.text)?? 0,
          'precioBoletos':double.tryParse(precioBoletosController.text)?? 0,
          'fechaInicio': startDate,
          'fechaFin': endDate
        };
        if(idDoc.isEmpty){
          await rifas.add(rifaData);
        }else{
          await rifas.doc(idDoc).update(rifaData);
        }

      Navigator.pop(
      context,
      MaterialPageRoute(builder: (context)=> HomePage()),
      );
      },
      child: Icon(Icons.save)
      ),
    );
  }
  Future<void> _performDeletion() async {
    if (idDoc.isNotEmpty) {
      await rifas.doc(idDoc).delete();
    }
  }
}
