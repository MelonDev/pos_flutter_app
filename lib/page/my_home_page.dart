import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posflutterapp/bloc/authentication/authentication_bloc.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';
import 'package:posflutterapp/page/splash_screen.dart';

import '../user_repository.dart';
import 'home_page.dart';
import 'login_page.dart';


class MyHomePage extends StatelessWidget {


  final UserRepository _userRepository;

  MyHomePage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExternalBloc>(
          create: (context) => ExternalBloc()
            ..add(
              InitialExternalEvent(),
            ),
        ),
        BlocProvider(
          create: (context) =>
              AuthenticationBloc(userRepository: _userRepository)
                ..add(
                  AuthenticationStarted(),
                ),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          // ignore: missing_return
          builder: (context, state) {
            if (state is InitialAuthenticationState) {
              return SplashScreen();
            }
            if (state is AuthenticationFailure) {
              return LoginScreen(
                userRepository: _userRepository,
              );
            }
            if (state is AuthenticationSuccess) {
              return HomePage();
            }
          },
        ),
      ),
    );
  }
}
