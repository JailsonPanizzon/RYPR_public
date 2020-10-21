import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:rypr/bloc/salvarCliente.dart';
import 'package:rypr/models/cliente.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class CadastroCliente extends StatefulWidget {
  @override
  _CadastroClienteState createState() => _CadastroClienteState();
}

class _CadastroClienteState extends State<CadastroCliente> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MaskTextInputFormatter _numberMaskFormatter = new MaskTextInputFormatter(
      mask: '(##) # ####-####', filter: {"#": RegExp(r'[0-9]')});
  TextEditingController _nomeController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _telefoneController = new TextEditingController();

  CadastroClienteBloc _bloc = BlocProvider.getBloc<CadastroClienteBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _heightField = 90;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastar cliente"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Container(
                  height: _heightField,
                  child: TextFormField(
                    validator: (value) {
                      return value.isEmpty ? "Preencha este campo" : null;
                    },
                    controller: _nomeController,
                    decoration: InputDecoration(labelText: "Nome"),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                Container(
                  height: _heightField,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        return EmailValidator.validate(value)
                            ? null
                            : "Email inválido";
                      }
                      return null;
                    },
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Container(
                  height: _heightField,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        return value.length < 16 ? "Numero inválido" : null;
                      }
                      return null;
                    },
                    controller: _telefoneController,
                    inputFormatters: [_numberMaskFormatter],
                    decoration: InputDecoration(labelText: "telefone"),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _salvar();
          }),
    );
  }

  _salvar() {
    if (_formKey.currentState.validate()) {
      Cliente cliente = Cliente(
          nome: _nomeController.text,
          telefone: _telefoneController.text,
          email: _emailController.text);
      _bloc.saveCliente(cliente, context);
    }
  }
}
