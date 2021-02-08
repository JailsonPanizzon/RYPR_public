import 'package:Hypr/view/cadastroCliente.dart';
import 'package:Hypr/view/listarClientes.dart';
import 'package:Hypr/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Hypr/widget/menuLateral.dart';
import 'package:Hypr/widget/myAppBar.dart';
import 'package:Hypr/widget/myBottomNavigator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double tamanhoContainer = MediaQuery.of(context).size.width / 2.5;
    return Scaffold(
      drawer: Drawer(
        elevation: 100,
        child: MenuLateral(),
      ),
      appBar: myAppBar(context, title: "Home", disableBack: true),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListarClientes()));
                },
                child: Container(
                  width: tamanhoContainer,
                  height: tamanhoContainer,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        color: Colors.white,
                        size: tamanhoContainer / 3,
                      ),
                      Text(
                        "Buscar              clientes",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 16, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CadastroCliente()));
                },
                child: Container(
                  width: tamanhoContainer,
                  height: tamanhoContainer,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: tamanhoContainer / 3,
                      ),
                      Text(
                        "Cadastrar          cliente",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 16, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                child: Container(
                  width: tamanhoContainer,
                  height: tamanhoContainer,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: tamanhoContainer / 3,
                      ),
                      Text(
                        "Meu                     Perfil",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 16, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 100,
          )
        ],
      )),
      bottomNavigationBar: MyBottomNavigator(),
    );
  }
}
