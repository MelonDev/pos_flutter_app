import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posflutterapp/bloc/firebase_crud/firebase_crud_bloc.dart';
import 'package:posflutterapp/bloc/firebase_products/firebase_products_bloc.dart';
import 'package:posflutterapp/page/home_page.dart';
import 'package:posflutterapp/page/login_page.dart';
import 'package:posflutterapp/page/splash_screen.dart';
import 'package:posflutterapp/user_repository.dart';

import 'bloc/authentication/authentication_bloc.dart';
import 'bloc/external/external_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
//  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(
    MyApp(
      userRepository: userRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({Key key, @required UserRepository userRepository})
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
        ),
        BlocProvider<FirebaseProductsBloc>(
          create: (context) => FirebaseProductsBloc()
            ..add(
              InitialFirebaseProductsEvent(),
            ),
        ),BlocProvider<FirebaseCrudBloc>(
          create: (context) => FirebaseCrudBloc()
            ..add(
              InitialFirebaseCrudEvent(),
            ),
        ),
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
