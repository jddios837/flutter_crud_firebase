import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_crud_firebase/src/models/product_model.dart';
import 'package:flutter_crud_firebase/src/providers/products_providers.dart';
import 'package:flutter_crud_firebase/src/utils/utils.dart' as util;

class ProductPage extends StatefulWidget {
  
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productProvider = new ProductsProvider();

  ProductModel producto = new ProductModel();

  bool _guardando = false;

  File foto;

  @override
  Widget build(BuildContext context) {

    final ProductModel prodData = ModalRoute.of(context).settings.arguments;
    if(prodData != null) {
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual), 
            onPressed: _seleccionarFoto
          ),
          IconButton(
            icon: Icon(Icons.camera_alt), 
            onPressed: _tomarFoto
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(context),
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _mostrarFoto() {

    if (producto.fotoUrl != null) {
 
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'), 
        image: NetworkImage(producto.fotoUrl),
        height: 300.0,
        fit: BoxFit.contain,
      );
 
    } else {
 
      if( foto != null ){
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
    // if(producto.fotoUrl != null) {
    //   return Container();
    // } else {
    //   return Image(
    //     image: AssetImage(foto?.path ?? 'assets/no-image.png'),
    //     height: 300.0,
    //     fit: BoxFit.cover,
    //   );
    // }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {

    foto = await ImagePicker.pickImage(
      source: origen
    );

    if (foto != null) {
      producto.fotoUrl = null;
    }

    setState(() {});
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        return value.length < 3 ? 'Ingrese el nombre del producto' : null; 
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {
        if(util.isNumeric(value)) {
          return null;
        } else {
          return 'Solo números';
        }
      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible, 
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){
        producto.disponible = value;
      })
    );
  }

  Widget _crearBoton(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: ( _guardando ) ? null: _submit,
    );
  }

  void _submit() async {
    // 1.- Check form validation, return if exist any error
    if (!formKey.currentState.validate()) return;
    // 2.- Execute onSaved in any TextFormField to update values in the model
    formKey.currentState.save();

    // _guardando = true;
    setState(() { _guardando = true; });

    if (foto != null) {
      producto.fotoUrl = await productProvider.uploadImage(foto);
    }


    print('Todo Ok');
    print(producto.titulo);
    print(producto.valor);
    print(producto.disponible);

    if (producto.id == null) {
      productProvider.crearProduct(producto);
    } else {
      productProvider.editarProducto(producto);
    }
    
    setState(() { _guardando = false; });
    mostrarSnackbar('Registro Guardado');

    Navigator.pushNamed(context, 'home');
    
  }

  void mostrarSnackbar(String mensaje) {

    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackBar);

  }
}