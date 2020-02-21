// import 'package:settings_app/src/pages/home_page.dart';
// import 'package:flutter_crud_firebase/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuarios {

  static final PreferenciasUsuarios _instancia = new PreferenciasUsuarios._internal();

  factory PreferenciasUsuarios() {
    return _instancia;
  }

  PreferenciasUsuarios._internal();

  SharedPreferences _prefs; 

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

//  bool   _colorSecundario;
//   int    _genero;
//   String _nombre;
  // GET & SET values
  get genero {
    return _prefs.getInt('genero') ?? 1;
  }

  set genero(int value) {
    _prefs.setInt('genero', value);
  }

  // GET & SET values
  get colorSecundario {
    return _prefs.getBool('colorSecundario') ?? false;
  }

  set colorSecundario(bool value) {
    _prefs.setBool('colorSecundario', value);
  }

  // GET & SET values
  get token {
    return _prefs.getString('token') ?? 'Pedro';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  // GET & SET values
  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }


}