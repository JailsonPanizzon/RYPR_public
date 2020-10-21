import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rypr/bloc/send.dart';
import 'package:rypr/bloc/listarClientes.dart';
import 'package:rypr/bloc/login.dart';
import 'package:rypr/bloc/salvarCliente.dart';
import 'package:rypr/config/theme.dart';

import 'package:rypr/view/splash.dart';

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
