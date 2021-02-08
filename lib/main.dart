import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:Hypr/bloc/send.dart';
import 'package:Hypr/bloc/listarClientes.dart';
import 'package:Hypr/bloc/login.dart';
import 'package:Hypr/bloc/salvarCliente.dart';
import 'package:Hypr/config/theme.dart';

import 'package:Hypr/view/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => LoginBloc()),
        Bloc((i) => CadastroClienteBloc()),
        Bloc((i) => ListarClientesBloc()),
        Bloc((i) => SendBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: themeData,
        home: MySplashScreen(),
      ),
    );
  }
}
