
import 'package:flutter_crud_firebase/src/share_prefs/preferencias_usuario.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_crud_firebase/src/models/product_model.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProductsProvider {
  final String _url = 'https://crud-flutter-app.firebaseio.com';
  final _prefs = PreferenciasUsuarios();

  Future<bool> crearProduct(ProductModel product) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';

    final resp = await http.post(url, body: productModelToJson(product));

    final decodeData = json.decode(resp.body);

    print(decodeData);

    return true;
  }

  Future<List<ProductModel>> cargarProductos() async {
    final url  = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic> decodeData = json.decode(resp.body);
    final List<ProductModel> productos = new List();

    if(decodeData==null) return [];

    decodeData.forEach((id, prod){
      // print(id);
      final prodTemp = ProductModel.fromJson(prod);
      prodTemp.id = id;
      productos.add(prodTemp);

       
    });

    print(productos);

    return productos;

  }

  Future<bool> borrarProducto(String id) async {
    final url  = '$_url/productos/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);
    
    print(json.decode(resp.body));

    return true;
  }

  Future<bool> editarProducto(ProductModel producto) async {
    final url  = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';
    final resp = await http.put(url, body: productModelToJsonUpdate(producto));

    final decodedData = json.decode(resp.body);
    
    print(decodedData);

    return true;
  }

  Future<String> uploadImage(File image ) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dznd4dx76/image/upload?upload_preset=kqzi3oih');
    final mimeType = mime(image.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
      image.path,
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];
  }

}