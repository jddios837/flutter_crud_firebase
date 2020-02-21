import 'package:flutter/material.dart';

import 'package:flutter_crud_firebase/src/block/provider.dart';

import 'package:flutter_crud_firebase/src/pages/home_page.dart';
import 'package:flutter_crud_firebase/src/pages/login_page.dart';
import 'package:flutter_crud_firebase/src/pages/product_page.dart';
import 'package:flutter_crud_firebase/src/pages/register_page.dart';
import 'package:flutter_crud_firebase/src/share_prefs/preferencias_usuario.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new PreferenciasUsuarios();
  await prefs.initPrefs();

  runApp(MyApp());
} 
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuarios();
    print(prefs.token);

    return Provider(child: 
      MaterialApp(
        title: 'Material App',
        initialRoute: 'login',
        routes: {
            'login'    : (BuildContext context) => LoginPage(),
            'home'     : (BuildContext context) => HomePage(),
            'product'  : (BuildContext context) => ProductPage(),
            'register'  : (BuildContext context) => RegisterPage()
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        )
      )
    );
    
    
  }
}