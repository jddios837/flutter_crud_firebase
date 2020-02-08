import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/src/block/login_bloc.dart';
export 'package:flutter_crud_firebase/src/block/login_bloc.dart';

class Provider extends InheritedWidget {

  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if(_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia;
  }

  final loginBloc = LoginBloc();

  Provider._internal({Key key, Widget child})
    : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
  // bool updateShouldNotify(InheritedWidget oldWidget) {
  //   // TODO: implement updateShouldNotify
  //   return null;
  // }

  static LoginBloc of ( BuildContext context ){
   return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
}
}