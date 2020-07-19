part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'RegisterEmailChanged { email :$email }';
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'RegisterPasswordChanged { password: $password }';
}

class RegisterSubmitted extends RegisterEvent {
  final BuildContext context;
  final String email;
  final String password;
  final String shopName;
  final String shopAddress;
  final String shopTax;
  final String shopNumber;


  const RegisterSubmitted(this.context,{
    @required this.email,
    @required this.password,
    @required this.shopName,
    @required this.shopAddress,
    @required this.shopTax,
    @required this.shopNumber,

  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'RegisterSubmitted { email: $email, password: $password }';
  }
}
