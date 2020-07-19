import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:posflutterapp/bloc/firebase_crud/firebase_crud_bloc.dart';
import 'package:posflutterapp/components/validators.dart';
import 'package:rxdart/rxdart.dart';

import '../../user_repository.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.initial();

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
    Stream<RegisterEvent> events,
    TransitionFunction<RegisterEvent, RegisterState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! RegisterEmailChanged &&
          event is! RegisterPasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is RegisterEmailChanged ||
          event is RegisterPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterEmailChanged) {
      yield* _mapRegisterEmailChangedToState(event.email);
    } else if (event is RegisterPasswordChanged) {
      yield* _mapRegisterPasswordChangedToState(event.password);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(event);
    }
  }

  Stream<RegisterState> _mapRegisterEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapRegisterPasswordChangedToState(
      String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
      RegisterSubmitted event
  ) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(
        email: event.email,
        password: event.password,
      );

      FirebaseCrudBloc().addShopDetail(AddShopDetailFirebaseCrudEvent(event.context, event.email, event.shopName, event.shopAddress, event.shopTax, event.shopNumber));


      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
