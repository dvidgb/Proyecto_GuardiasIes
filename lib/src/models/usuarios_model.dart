class Usuario {
  List<Usuarios> items = new List();

  Usuario();

  Usuario.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final usuario = new Usuarios.fromJsonMap(item);
      items.add(usuario);
    }
  }
}

class Usuarios {
  String id;
  String usuario;
  String password;

  Usuarios({
    this.id,
    this.usuario,
    this.password,
  });

  Usuarios.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    usuario = json['usuario'];
    password = json['password'];
  }
}
