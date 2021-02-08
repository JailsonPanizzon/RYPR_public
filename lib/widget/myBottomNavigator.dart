import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Hypr/models/cliente.dart';
import 'package:Hypr/view/cadastroCliente.dart';
import 'package:Hypr/view/comporMensagem.dart';
import 'package:Hypr/view/home.dart';
import 'package:Hypr/view/listarClientes.dart';
import 'package:Hypr/view/profile.dart';

class MyBottomNavigator extends StatelessWidget {
  MyBottomNavigator({this.listSelected});
  final List<Cliente> listSelected;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 80,
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (contex) => Home(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (contex) => ListarClientes(),
                    ),
                  );
                },
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (contex) => CadastroCliente(),
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 0, 214, 1),
                          Color.fromRGBO(255, 77, 0, 1)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 100.0, minHeight: 30.0),
                    alignment: Alignment.center,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.message),
                onPressed: listSelected != null && listSelected.length > 0
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComporMensagem(
                              clientes: listSelected,
                            ),
                          ),
                        );
                      }
                    : null,
              ),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
