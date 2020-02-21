import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/src/block/provider.dart';
import 'package:flutter_crud_firebase/src/models/product_model.dart';
import 'package:flutter_crud_firebase/src/providers/products_providers.dart';

class HomePage extends StatelessWidget {

  final productsProvider = new ProductsProvider();

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page')
      ),
      body: _crearListado(),
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

  Widget _crearListado() {
    return FutureBuilder(
      future: productsProvider.cargarProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {

          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (BuildContext context, int index) => _crearItem(context, productos[index]),
          );
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductModel producto) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction){
        productsProvider.borrarProducto(producto.id);
      },
      child: Card(
        child: Column(
          children: <Widget>[

            (producto.fotoUrl == null)
              ? Image(image: AssetImage('assets/no-image.png'))
              : FadeInImage(
                  placeholder: AssetImage('assets/jar-loading.gif'), 
                  image: NetworkImage(producto.fotoUrl),
                  height: 300.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

            ListTile(
              title: Text('${producto.titulo} - ${producto.valor}'),
              subtitle: Text(producto.id),
              onTap: () => Navigator.pushNamed(context, 'product', arguments: producto),
            ),    
          ],
        ),
      )
    );
  }


}