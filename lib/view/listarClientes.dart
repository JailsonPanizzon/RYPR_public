import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Hypr/bloc/listarClientes.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:Hypr/models/cliente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Hypr/widget/itemLista.dart';
import 'package:Hypr/widget/myAppBar.dart';
import 'package:Hypr/widget/myBottomNavigator.dart';
import 'package:Hypr/widget/customButton.dart';

class ListarClientes extends StatefulWidget {
  @override
  _ListarClientesState createState() => _ListarClientesState();
}

class _ListarClientesState extends State<ListarClientes> {
  ListarClientesBloc _bloc = BlocProvider.getBloc<ListarClientesBloc>();
  List<Cliente> _selecteds = [];
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  int _sexoGroup;
  int _idadeGroup;
  @override
  void initState() {
    _bloc.getClientes(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      endDrawer: filterDrawer(),
      appBar: myAppBar(
        context,
        title: "Clientes",
        traling: [
          IconButton(
            icon: Icon(Icons.tune),
            onPressed: () {
              _globalKey.currentState.openEndDrawer();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _bloc.getClientes(context),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (snapShot.hasData) {
            List<Cliente> lista = _bloc.convert(snapShot.data.documents);
            return _buildList(lista);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: MyBottomNavigator(listSelected: _selecteds),
    );
  }

  Cliente containsDocument(Cliente element) {
    for (Cliente e in _selecteds) {
      if (e.idDoc == element.idDoc) return e;
    }
    return null;
  }

  changeSexGroup(dynamic value) {
    if (_idadeGroup == null) {
      _bloc.filtro = value;
    } else {
      _bloc.filtro = (_idadeGroup + 1) * 3 + value;
    }
    setState(() {
      _sexoGroup = value;
    });
  }

  changeIdadeGroup(dynamic value) {
    if (_sexoGroup == null) {
      _bloc.filtro = value + 3;
    } else {
      _bloc.filtro = (value + 1) * 3 + _sexoGroup;
    }
    setState(() {
      _idadeGroup = value;
    });
  }

  Widget _buildList(List<Cliente> _clientes) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _clientes.length,
      itemBuilder: (BuildContext context, int index) {
        Cliente e = containsDocument(_clientes[index]);
        return ItemList(
            cliente: _clientes[index],
            selected: e != null,
            onSelect: (value) {
              if (value) {
                _selecteds.add(_clientes[index]);
              } else {
                _selecteds.remove(e);
              }
              setState(() {});
            });
      },
    );
  }

  Widget filterDrawer() {
    return Drawer(
      child: Container(
        height: 300,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 70,
            ),
            Text(
              "Filtros",
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 15,
            ),
            Text("Sexo "),
            Container(
              child: Column(
                children: <Widget>[
                  RadioListTile(
                      title: Text("Masculino"),
                      value: 1,
                      groupValue: _sexoGroup,
                      onChanged: changeSexGroup),
                  RadioListTile(
                      title: Text("Feminino"),
                      value: 2,
                      groupValue: _sexoGroup,
                      onChanged: changeSexGroup),
                  RadioListTile(
                      title: Text("Outro"),
                      value: 3,
                      groupValue: _sexoGroup,
                      onChanged: changeSexGroup),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text("Faixa Etária "),
            Container(
              child: Column(
                children: <Widget>[
                  RadioListTile(
                      title: Text("Até 25 anos"),
                      value: 1,
                      groupValue: _idadeGroup,
                      onChanged: changeIdadeGroup),
                  RadioListTile(
                      title: Text("25 anos à 45 anos"),
                      value: 2,
                      groupValue: _idadeGroup,
                      onChanged: changeIdadeGroup),
                  RadioListTile(
                      title: Text("45 anos ou mais"),
                      value: 3,
                      groupValue: _idadeGroup,
                      onChanged: changeIdadeGroup),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 200,
              child: CustomButtom(
                text: "Limpar",
                textColor: Colors.white,
                color: Colors.black,
                onPress: () {
                  _bloc.filtro = 0;
                  setState(() {
                    _sexoGroup = null;
                    _idadeGroup = null;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
