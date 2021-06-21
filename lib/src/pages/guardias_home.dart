import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:prueba_seneca/src/pages/personal_centro.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class GuardiasHome extends StatefulWidget {
  @override
  _GuardiasHomeState createState() => _GuardiasHomeState();
}

class _GuardiasHomeState extends State<GuardiasHome> {
  CalendarController _calendarController; //controlador del calendario

//Variables fecha para el calendario
  String _subjectText,
      _startTimeText,
      _endTimeText,
      _dateText,
      _timeDetails,
      _dia_fecha_seleccionada;
  String lunes = 'Lunes.xsls';

  CalendarTapDetails details;

  @override
  void initState() {
    Intl.defaultLocale = 'es_ES';
    _calendarController = CalendarController();
    _subjectText = '';
    _startTimeText = '';
    _endTimeText = '';
    _dateText = '';
    _timeDetails = '';
    _dia_fecha_seleccionada =
        ''; //guarda solo el dia seleccinado LUN,MAR,MIE,JUE,VIE...
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//para ver los nombres de los profesores de la pagina personal_centro
//para coger los nombres de los profesores
//para coger los nombres de los profesores
    final List<String> _nombreprofes =
        ModalRoute.of(context).settings.arguments;

    print("Está en el BuildContext " + _nombreprofes.toString());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Container(
          //width: 350,
          //height: 350,
          child: Column(
            children: [
              Row(
                children: [
                  // _boton_retroceder(),
                  // _boton_avanzar(),
                ],
              ),
              SizedBox(height: 120, width: 100),
              _calendario(),
              SizedBox(height: 50.0),
              // ignore: deprecated_member_use

              RaisedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PersonalCentro())),
                color: Colors.blueGrey,
                textColor: Colors.white,
                child: Text('Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _calendario() {
    return Center(
      child: SfCalendar(
        view: CalendarView.month,
        controller: _calendarController,
        firstDayOfWeek: 1,
        showNavigationArrow: true,
        onTap: calendarTapped,
      ),
    );
  }

  void calendarTapped(CalendarTapDetails details) {
    //final List<String> _nombreprofes = ModalRoute.of(context).settings.arguments;

    //String _nombre_profesor = "";

    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Appointment appointmentDetails = details.appointments[0];
      _subjectText = appointmentDetails.subject;
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.startTime)
          .toString();
      _startTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.startTime).toString();
      _endTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.endTime).toString();
      _timeDetails = '$_startTimeText - $_endTimeText';
    } else if (details.targetElement == CalendarElement.calendarCell) {
      _subjectText = "Fecha Seleccionada";
      _dateText = DateFormat('dd/MM/yyyy').format(details.date).toString();
      _dia_fecha_seleccionada = DateFormat('E').format(details.date).toString();
      _timeDetails = '';

      showDialog(
          context: context,
          builder: (BuildContext context) {
            final List<String> _nombreprofes =
                ModalRoute.of(context).settings.arguments;
            print("Está en el Dialog " + _nombreprofes.toString());
            return AlertDialog(
              title: Container(child: new Text('$_subjectText')),
              content: Container(
                height: 80,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Desea crear hoja para el dia: $_dateText',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          Text(_timeDetails,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 15)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  children: [
                    new TextButton(
                        onPressed: () {
                          //realiza la copia del modelo de hoja de cáculo con la fecha que se selecciona en el calendario
                          _mensajeHojaCreada();

                          /*  for (var i = 0; i <= _nombreprofes.length; i++) {
                            // _nombre_profesor = _nombreprofes[i].toString();
                            print(_nombreprofes[i].toString());
                          }*/

                          print(_nombreprofes.toString());

                          //final String n = "Martínez Ruiz, Francisco";

                          if (_dia_fecha_seleccionada == "lun.") {
                            /*Map<String, dynamic> args = {
                              "names": "Martínez Ruiz, Francisco"
                            };
                            String url =
                                "https://script.google.com/macros/s/AKfycbzMBHQ-YKEHl3yYZ7jxtdHbH5GjoKPzE_ag_Bq-Q7tKWSm_T93816OY9ORiPa9eAMCn/exec";
                            var body = json.encode(args);
                            print(body);
                            http.post(url,
                                body: body,
                                headers: {'Content-type': 'application/json'});

                             */

                            /*  var uri = Uri(
                              scheme: 'http',
                              host: 'script.google.com',
                              path:
                                  'macros/s/AKfycbzB4lsjq99ochW1h39E_3C6LAXA0cB3zY4jSiOSJMiKdlHeuD6Wb7d2d7cG1Sq_ZblEEw/exec',
                              queryParameters: {
                                'valor': ['Serrano Reche, Mercedes'],
                              },
                            );
                            print(uri);
                            */
                            http.get(
                                'https://script.google.com/macros/s/AKfycbz_YXttXb-6nlI9salDyRqULgbsR6yOL7XejNyvCPYhlxO0XsJxP5HCzLjwtB-mYwf3EQ/exec?fecha=' +
                                    _dateText);
                          }
                          if (_dia_fecha_seleccionada == "mar.") {
                            http.get(
                                'https://script.google.com/macros/s/AKfycbwpa5-z592c1GgTo9_zvQUMhr3YXjnpSQfLs0N1zwSZuaNeOK8aKYRDEoaqBCf6Rq42/exec?fecha=' +
                                    _dateText);
                          }
                          if (_dia_fecha_seleccionada == "mié.") {
                            http.get(
                                'https://script.google.com/macros/s/AKfycbxUtOEYulSSgiFQBAnwAxg1JEtGgA2bZgopTfBMe8YpuIUOd3-Ky3vNKNNlVCOh5l_J/exec?fecha=' +
                                    _dateText);
                          }
                          if (_dia_fecha_seleccionada == "jue.") {
                            http.get(
                                'https://script.google.com/macros/s/AKfycbwFAufiubF3jpU0436Cv_OeKmUXvKw-QcHCOdW1LKORHXDLJwGBb_G1XmDLtaYUlU65AA/exec?fecha=' +
                                    _dateText);
                          }
                          if (_dia_fecha_seleccionada == "vie.") {
                            http.get(
                                'https://script.google.com/macros/s/AKfycbyImvq94zrM1WnGWB9P7Nuh5TM0H8mNYQLC9qox3E_NCOKq-Cqst8ewuWZtG_EVj3NDCA/exec?fecha=' +
                                    _dateText);
                          }
                        },
                        child: Text('Crear Hoja')),
                    new FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: new Text('Cerrar')),
                  ],
                )
              ],
            );
          });
    }
  }

  Widget _mensajeHojaCreada() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('La hoja se ha creado con éxito!'),
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
