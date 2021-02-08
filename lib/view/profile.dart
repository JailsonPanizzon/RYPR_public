import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Hypr/bloc/login.dart';
import 'package:Hypr/widget/customButton.dart';
import 'package:Hypr/widget/myAppBar.dart';
import 'package:Hypr/widget/myBottomNavigator.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class Profile extends StatefulWidget {
  Profile();

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  LoginBloc _bloc = BlocProvider.getBloc<LoginBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, title: "Perfil"),
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
                      " ",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              CustomButtom(
                  text: "Sincronizar seus contatos",
                  color: Colors.white,
                  borderColor: Colors.black,
                  onPress: () {
                    _bloc.sincronizarContatos(context);
                  }),
              SizedBox(height: 20),
              CustomButtom(
                  text: "Logout",
                  color: Colors.red,
                  textColor: Colors.white,
                  borderColor: Colors.red,
                  onPress: () {
                    _bloc.logOut(context);
                  }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigator(),
    );
  }
}
