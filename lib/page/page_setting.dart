import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posflutterapp/bloc/authentication/authentication_bloc.dart';




import '../user_repository.dart';
import 'cart.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  final String name;
  final String email;
  final UserRepository _userRepository;

  _SettingPageState(
      {Key key, @required this.name, this.email, UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.purple),
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Text(
          'ตั้งค่า',
          style: TextStyle(color: Colors.purple, fontSize: 30),
        ),
      ),

      body: Container(
        margin: const EdgeInsets.only(left: 40, right: 40),
//          mainAxisAlignment: MainAxisAlignment.center,

        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(
                "$name",
              ),
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              accountEmail: Text(
                "$email",
              ),
            ),

            InkWell(
              onTap: () {
                BlocProvider.of<AuthenticationBloc>(context).add(
                  AuthenticationLoggedOut(),
                );
              },
              child: ListTile(
                title: Text('Log out'),
                leading: Icon(Icons.highlight_off),
              ),
            ),
          ],
        ),
      ),


    );
  }
}
