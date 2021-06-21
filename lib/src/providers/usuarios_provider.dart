import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:prueba_seneca/src/models/usuarios_model.dart';

class UsuariosProvider {
  String _spreadsheetId = '1_6BE4qjZ4CuDgvfF0u4EjnBknsTDpMq_4q0cpXDkgCs';
  String _url = 'script.google.com';
  String _sheet = 'usuarios';

  Future<List<Usuarios>> getDatos() async {
    final url = Uri.https(
        _url,
        'macros/s/AKfycbwfDe5eT0veFRIj_uLLS-CrkL2B4Kll2ftE9HVnr1aontId-9qO/exec',
        {
          'spreadsheetId': _spreadsheetId,
          'sheet': _sheet,
        });

    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    print(decodeData);

    final user = new Usuario.fromJsonList(decodeData);

    return user.items;
  }
}
