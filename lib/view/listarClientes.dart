import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rypr/bloc/listarClientes.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rypr/models/cliente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rypr/widget/itemLista.dart';
import 'package:rypr/widget/myAppBar.dart';
import 'package:rypr/widget/myBottomNavigator.dart';

class ListarClientes extends StatefulWidget {
  @override
  _ListarClientesState createState() => _ListarClientesState();
}

class _ListarClientesState extends State<ListarClientes> {
  ListarClientesBloc _bloc = BlocProvider.getBloc<ListarClientesBloc>();
  List<Cliente> _selecteds = [];
  @override
  void initState() {
    _bloc.getClientes(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, title: "Clientes"),
      body: StreamBuilder<QuerySnapshot>(
        stream: _bloc.getClientes(context),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (snapShot.hasData) {
            List<Cliente> lista = _bloc.convert(snapShot.data.documents);
            return _buildList(lista);
          }
          return CircularProgressIndicator();
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
}
