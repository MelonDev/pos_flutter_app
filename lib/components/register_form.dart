import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posflutterapp/bloc/authentication/authentication_bloc.dart';

import 'package:posflutterapp/bloc/register/register_bloc.dart';
import 'package:posflutterapp/widgets/register_button.dart';

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.recent_actors,
                          color: Colors.purple,
                          size: 100,
                        ), // icon
                        Text(
                          "REGISTER",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 60,
                              fontWeight: FontWeight.bold),
                        ), // text
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      elevation: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.email,
                              color: Colors.purple,
                            ),
                            labelText: 'Email',
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          autovalidate: true,
                          // ignore: missing_return
                          validator: (_) {
                            if (_.isEmpty) {
                              Pattern pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+9\.[^<>()[\]\\.,;:\s@\"]+)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))S';
                              RegExp regex = new RegExp(pattern);
                              if (!regex.hasMatch(_)) if (!state.isEmailValid) {
                                return 'Please make sure your email address is valid';
                              } else {
                                return null;
                              }
                              else
                                return !state.isEmailValid
                                    ? 'Please make sure your email address is valid'
                                    : null;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      elevation: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.lock,
                              color: Colors.purple,
                            ),
                            labelText: 'Password',
                            border: InputBorder.none,
                          ),
                          obscureText: true,
                          autocorrect: false,
                          autovalidate: true,
                          validator: (_) {
                            if (_.isEmpty) {
                              if (!state.isPasswordValid) {
                                return 'The password field cannot be empty';
                              }
                            } else if (_.length < 8) {
                              if (!state.isPasswordValid) {
                                return 'The password has to be at least 8 characters long';
                              }
                            }
                            return !state.isPasswordValid
                                ? 'Invalid Password'
                                : null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        RegisterButton(
                          onPressed: isRegisterButtonEnabled(state)
                              ? _onFormSubmitted
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.add(
      RegisterEmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      RegisterPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      RegisterSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
