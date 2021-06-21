import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:prueba_seneca/src/models/usuarios_permitidos.dart';
import 'package:prueba_seneca/src/pages/guardias_home.dart';

import 'package:prueba_seneca/src/providers/usuarios_permitidos_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:multi_select_item/multi_select_item.dart';

import 'dart:js' as js;

import 'package:http/http.dart' as http;

class PersonalCentro extends StatelessWidget {
  //final PersonalProvider persona = new PersonalProvider();

  final ProfesorProvider profesor = new ProfesorProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      body: FutureBuilder(
        future: profesor.getProfesor(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return _ListaProfesor(snapshot.data);
          }
        },
      ),
    );
  }
}

class _ListaProfesor extends StatefulWidget {
  final List<Profesores> p;

  _ListaProfesor(this.p);

  @override
  __ListaProfesoresState createState() => __ListaProfesoresState();
}

class __ListaProfesoresState extends State<_ListaProfesor> {
  //MultiSelectController controller = new MultiSelectController();
  List<String> _selectedItems = List<String>();

  List<int> _selectedIndex = List<int>();

//int _selectedIndex = 0;
/*
  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }*/ //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        SizedBox(height: 100),
        Text('Seleccione los profesores a insertar'),
        SizedBox(height: 100),
        Expanded(
          child: ListView.builder(
              itemCount: widget.p.length,
              itemBuilder: (context, int index) {
                final profe = widget.p[index];

                return Container(
                  height: 50,
                  color: (_selectedIndex.contains(index))
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.transparent,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: ListTile(
                        title: Center(child: Text('${profe.usuario}')),
                        onTap: () {
                          ///mostrarDialogo(context, widget.p[index]);
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => ProfesorDatos()));

                          if (!_selectedIndex.contains(index)) {
                            setState(() {
                              _selectedIndex.add(index);
                            });
                          } else {
                            if (_selectedIndex.contains(index)) {
                              setState(() {
                                _selectedIndex
                                    .removeWhere((val) => val == index);
                              });
                            }
                          }

                          if (!_selectedItems.contains(profe)) {
                            setState(() {
                              _selectedItems.add(profe.usuario);
                              //_onSelected(index);
                            });
                          }
                        }),
                  ),
                );
              }),
        ),
        SizedBox(height: 25),
        TextButton(
          onPressed: () {
            print('Funciono cuando me pulsas');

            print(_selectedItems.join("\n"));

            var uri = Uri(
              scheme: 'https',
              host: 'script.google.com',
              path:
                  'macros/s/AKfycbz_XI5cFD0Q69Loe1-paGhkU6IGlp7RumWdubdrgmvy4Q_7d20d6hT5uz4f40b5BEuzQA/exec',
              queryParameters: {
                'array': _selectedItems,
              },
            );
            print(uri);

            http.get(uri);
            _mensajeInsercion();
            //http.get('https://script.google.com/macros/s/AKfycbz_XI5cFD0Q69Loe1-paGhkU6IGlp7RumWdubdrgmvy4Q_7d20d6hT5uz4f40b5BEuzQA/exec');

            //http.get('https://script.google.com/macros/s/AKfycbyf6KYujWz4sE6zFdPRz1aELLNZn-y2OCf2p8rH9MjEABaH2tVIoF2656eXgv_9vQh43Q/exec');

            //Aquí va el script que recorre la caperta con las hojas de cáculo, recoge la última creada
            //y hace la inserción de los profesores seleccinados.
          },
          child: Text('Insertar'),
        ),
        SizedBox(height: 25),
        TextButton(
            onPressed: () {
              //https://script.google.com/macros/s/AKfycbxk4ENHhFFdmX_-_lSZ3HNtDX1gWO8TVO-gzlWZChnxDgUhd6d3VBse_c3C_Duyc0A77A/exec
              js.context.callMethod('open', [
                'https://script.google.com/macros/s/AKfycbzffgAcL-OToy4bpKJmbqsEm9UM5x91YBdlyr3tFrWUqCuJapMEvLgdF1p1PyA6o-O2dQ/dev?page=index'
              ]);
            },
            child: Text('Ir a GOOGLE SITES')),
      ],
    ));
  }

  Widget _mensajeInsercion() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('Se ha insertado correctamente los datos seleccionados'),
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
}
