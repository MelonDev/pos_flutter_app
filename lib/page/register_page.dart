import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:posflutterapp/bloc/register/register_bloc.dart';
import 'package:posflutterapp/components/register_form.dart';

import '../user_repository.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;

  RegisterScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.purple),
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Text(
          'Register',
          style: TextStyle(
            color: Colors.purple,
          ),
        ),
      ),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository: _userRepository),
          child: RegisterForm(),
        ),
      ),
    );
  }
}
