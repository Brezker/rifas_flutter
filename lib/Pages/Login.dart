import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'Home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _form = GlobalKey<FormState>();
  final txtUserController = TextEditingController();
  final txtPasswordController = TextEditingController();
  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: txtUserController.text, password: txtPasswordController.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> HomePage()),
      );

      if (userCredential.user == null) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Credenciales invalidas',
        );
        //print("acceso no valido ${userCredential.user?.email}");
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Transaction Completed Successfully',
        );
        //print("Acceso correcto");
      }
    } catch (e) {
      print("Ocurrio un error: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Login")
      ),*/
      body: Form(
        key: _form,
        child: Column(
          // decoration: BoxDecoration(gradient: LinearGradient(colors: )),
          children: [
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/5087/5087579.png',
              width: 300,
              height: 300,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                  controller: txtUserController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Usuario"),
                  validator: (value) {
                    if (value == "") {
                      return "este campo es obligatorio";
                    }
                    return null;
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                controller: txtPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Contraseña"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextButton(
                onPressed: () {
                  var isValid = _form.currentState?.validate();
                  if (isValid == null || !isValid) {
                    return;
                  }
                  _login();
                },
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: const Text("Accesar"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
