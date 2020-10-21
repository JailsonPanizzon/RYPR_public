import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rypr/bloc/send.dart';
import 'package:rypr/models/cliente.dart';
import 'package:rypr/widget/customButton.dart';
import 'package:rypr/widget/itemLista.dart';
import 'package:rypr/widget/myAppBar.dart';
import 'package:rypr/widget/myBottomNavigator.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class ComporMensagem extends StatefulWidget {
  ComporMensagem({this.clientes});
  final List<Cliente> clientes;

  @override
  _ComporMensagemState createState() => _ComporMensagemState();
}

class _ComporMensagemState extends State<ComporMensagem> {
  TextEditingController _msgController = TextEditingController();

  SendBloc _bloc = BlocProvider.getBloc<SendBloc>();

  Map<String, bool> _meiosEnvio = {
    "email": false,
    "whatsapp": false,
    "sms": false
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _heightField = 90;
    return Scaffold(
      appBar: myAppBar(context, title: "Compor"),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(
                height: _heightField,
                child: Card(
                  color: Colors.grey,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 8,
                      validator: (value) {
                        if (value.isNotEmpty) {
                          return "Este campo deve ser preenchido";
                        }
                        return null;
                      },
                      controller: _msgController,
                      decoration:
                          InputDecoration.collapsed(hintText: "Mensagem"),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: _meiosEnvio["email"],
                          onChanged: (value) {
                            _meiosEnvio["email"] = value;
                            setState(() {});
                          }),
                      Text("Email")
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: _meiosEnvio["whatsapp"],
                          onChanged: (value) {
                            _meiosEnvio["whatsapp"] = value;
                            setState(() {});
                          }),
                      Text("Whatsapp")
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: _meiosEnvio["sms"],
                          onChanged: (value) {
                            _meiosEnvio["sms"] = value;
                            setState(() {});
                          }),
                      Text("SMS")
                    ],
                  ),
                ],
              ),
              Text("Eviar para:"),
              Column(
                children: _buildList(widget.clientes),
              ),
              CustomButtom(
                text: "Enviar",
                color: Colors.white,
                borderColor: Colors.black,
                onPress: () {
                  _enviarMsg();
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigator(),
    );
  }

  List<Widget> _buildList(List<Cliente> _clientes) {
    return _clientes.map((cliente) {
      return ItemList(cliente: cliente);
    }).toList();
  }

  _enviarMsg() {
    _bloc.sendMsg(widget.clientes, _msgController.text, _meiosEnvio);
  }
}
