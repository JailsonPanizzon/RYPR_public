import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rypr/bloc/login.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rypr/view/cadastroCliente.dart';
import 'package:rypr/view/listarClientes.dart';

class MenuLateral extends StatelessWidget {
  static LoginBloc bloc = BlocProvider.getBloc<LoginBloc>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: size.height * 0.2,
            child: Center(
              child: Text("Logo bem bonito"),
            ),
          ),
          ListTile(
            title: Text("Cadastrar cliente"),
            leading: Icon(Icons.person_add),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CadastroCliente()));
            },
          ),
          ListTile(
            title: Text("Listar clientes"),
            leading: Icon(Icons.people),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListarClientes()));
            },
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              bloc.logOut(context);
            },
          )
        ],
      ),
    );
  }
}
