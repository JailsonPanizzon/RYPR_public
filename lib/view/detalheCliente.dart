import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Hypr/bloc/listarClientes.dart';
import 'package:Hypr/models/cliente.dart';
import 'package:Hypr/view/comporMensagem.dart';
import 'package:Hypr/widget/customButton.dart';
import 'package:Hypr/widget/myAppBar.dart';
import 'package:Hypr/widget/myBottomNavigator.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class DetalheCliente extends StatefulWidget {
  DetalheCliente({this.cliente});
  final Cliente cliente;

  @override
  _DetalheClienteState createState() => _DetalheClienteState();
}

class _DetalheClienteState extends State<DetalheCliente> {
  ListarClientesBloc _bloc = BlocProvider.getBloc<ListarClientesBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _heightField = 45;
    return Scaffold(
      appBar: myAppBar(context, title: widget.cliente.nome.split(" ")[0]),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      size: 100,
                    ),
                    Text(
                      widget.cliente.nome,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              CustomButtom(
                text: "Mensagem",
                color: Colors.white,
                borderColor: Colors.black,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ComporMensagem(clientes: [widget.cliente])));
                },
              ),
              SizedBox(height: 20),
              CustomButtom(
                  text: "Excuir",
                  color: Colors.red,
                  textColor: Colors.white,
                  borderColor: Colors.red,
                  onPress: () {
                    _bloc.deleteSelecteds([widget.cliente], context);
                  }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                    width: 400,
                  ),
                  Container(
                    height: _heightField,
                    child: Text("Nome : ${widget.cliente.nome}"),
                  ),
                  Container(
                    height: _heightField,
                    child: Text("Email : ${widget.cliente.email}"),
                  ),
                  Container(
                    height: _heightField,
                    child: Text("Telefone : ${widget.cliente.telefone}"),
                  ),
                  Container(
                    height: _heightField,
                    child: Text(
                      "Endereço: " +
                          (widget.cliente.endereco != null
                              ? widget.cliente.endereco
                              : " "),
                    ),
                  ),
                  Container(
                    height: _heightField,
                    child: Text(
                      "Sexo: " +
                          (widget.cliente.sexo != null
                              ? widget.cliente.sexo
                              : " "),
                    ),
                  ),
                  Container(
                    height: _heightField,
                    child: Text(
                      "Faixa etária: " +
                          (widget.cliente.faixaEtaria != null
                              ? widget.cliente.faixaEtaria
                              : " "),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigator(),
    );
  }
}
