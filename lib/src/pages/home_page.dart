import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/src/block/provider.dart';

class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page')
      ),
      body: Column(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'product'),
      backgroundColor: Colors.deepPurple,
    );
  }
}