import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:prueba_seneca/src/models/usuarios_permitidos.dart';

class ProfesorProvider {
  String _spreadsheetId = '19AMgWY-xKC9Mi8N3Bt7m3hSr9XixQq0V1ife1vipdZw';
  String _url = 'script.google.com';
  String _sheet = 'usuarios_permitidos';

  Future<List<Profesores>> getProfesor() async {
    final url = Uri.https(
        _url,
        'macros/s/AKfycbyhnXYH8HFnQoTqyrYhtXJRcuM1ft271v8Au1Dy02aEP5k5xLm6/exec',
        {
          'spreadsheetId': _spreadsheetId,
          'sheet': _sheet,
        });

    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    print(decodeData);

    final per = new Profesor.fromJsonList(decodeData);

    return per.items;
  }
}
