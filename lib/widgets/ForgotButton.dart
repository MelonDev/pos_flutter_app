//import 'package:flutter/material.dart';
//import 'package:posflutterapp/page/ForgotPasswordPage.dart';
//import 'package:posflutterapp/page/register_page.dart';
//
//import '../user_repository.dart';
//
//class ForgotButton extends StatelessWidget {
//  final UserRepository _userRepository;
//
//  ForgotButton({Key key, @required UserRepository userRepository})
//      : assert(userRepository != null),
//        _userRepository = userRepository,
//        super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return FlatButton(
//      child: Text(
//        'Forgot Password?',
//      ),
//      onPressed: () {
//        Navigator.of(context).push(
//          MaterialPageRoute(builder: (context) {
//            return ForgotPasswodPage(userRepository: _userRepository);
//          }),
//        );
//      },
//    );
//  }
//}
