import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prueba_seneca/src/models/usuarios_model.dart';
import 'package:prueba_seneca/src/pages/guardias_home.dart';
import 'package:prueba_seneca/src/pages/personal_centro.dart';

import 'package:prueba_seneca/src/providers/usuarios_provider.dart';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogginPage extends StatefulWidget {
  @override
  LogginPageState createState() => LogginPageState();
}

class LogginPageState extends State<LogginPage> {
  final UsuariosProvider usuario = new UsuariosProvider();

  final Usuarios u = new Usuarios();

  final myController = TextEditingController();
  final myController2 = TextEditingController();

  final List<Usuarios> usuarios;

  //para ocultar la password
  // Inicia la password con puntos ocultándola
  bool _obscureText = true;

  // Controla el estado de si se muestra o no la password
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  LogginPageState({this.usuarios});

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          width: width,
          padding: EdgeInsets.only(top: 120.0),
          height: height * 10.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _titulo(),
              Container(width: width * 0.85, child: _textFieldUsuario()),
              SizedBox(height: 25.0),
              Container(width: width * 0.85, child: _textFieldPassword()),
              SizedBox(height: 25.0),
              Container(
                  width: width * 0.85, height: 40.0, child: _botonEntrar()),
              SizedBox(height: 25.0),
              //_recordarpassword(),
              SizedBox(height: 25.0),
            ],
          )),
    );
  }

  //titulo
  Widget _titulo() {
    return Image(
      image: AssetImage('assets/app_guardias_jandula.png'),
      height: 300,
      width: 500,
    );
  }

  Widget _textFieldUsuario() {
    return TextField(
        controller: myController,
        decoration: InputDecoration(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            labelText: 'Usuario',
            labelStyle: TextStyle(color: Colors.black)));
  }

  Widget _textFieldPassword() {
    return TextField(
      controller: myController2,
      obscureText: _obscureText,
      decoration: InputDecoration(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        labelText: 'Contraseña',
        labelStyle: TextStyle(color: Colors.black),
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye, color: Colors.black),
          onPressed: _toggle,
        ),
      ),
    );
  }

  Widget _botonEntrar() {
    return FlatButton(
      color: Colors.blueGrey,
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(10.0),
      splashColor: Colors.blueAccent,
      onPressed: () {
        comprobarUsuario(context);
        comprobaremail();
        comprobarPassword();
        //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      },
      child: Text(
        "Entrar",
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

/*
  Widget _recordarpassword() {
    return Text(
      'No recuerdo mi contraseña',
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.black,
        decoration: TextDecoration.underline,
      ),
    );
  }
*/

  void comprobarUsuario(BuildContext context) async {
    final usuarios = await usuario.getDatos(); //usuariosProvider lo hemos
    //definido como atributo.
    usuarios.forEach((user) {
      if (user.usuario == myController.text &&
          user.password == myController2.text) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GuardiasHome()));
      } else {
        _mensajeUsuarioNoexiste();
      }
      ;
    });
  }

  //para probar lo que se introduce en las cajas de texto
  void comprobaremail() {
    String email = myController.text;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (emailValid == true) {
      print('Email válido');
    } else {
      print('No cumple las condicciones de un email.');
      _emailError(context);
    }
  }

  //mensaje de error de email no válido
  _emailError(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ERROR"),
      content: Text("Email introducio no cumple las condiciones establecidas"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _mensajeUsuarioNoexiste() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email no existe en el sistema.'),
            actions: [
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Aceptar'))
                ],
              )
            ],
          );
        });
  }

  //para validar una contreña
  void comprobarPassword() {
    String password = myController2.text;

    bool passwordValid =
        RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[_!@#\$&*~]).{8,}$")
            .hasMatch(password);

    if (passwordValid == true) {
      print('password válido');
    } else {
      print('No cumple las condicciones de seguridad.');
      _passwordError(context);
    }
  } //fin método comprobarPassword

  //mensaje de error de password no válido
  _passwordError(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ERROR PASSWORD"),
      content: Text(
          "La contraseña debe tener una logintud de 8 carácteres, en los que debe de haber como mínimo una letra mayúscula, una misnúscula, un carácter especial y un número"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
