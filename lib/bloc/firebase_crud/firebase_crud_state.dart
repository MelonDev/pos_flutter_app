part of 'firebase_crud_bloc.dart';

@immutable
abstract class FirebaseCrudState {}

class InitialFirebaseCrudState extends FirebaseCrudState {
  final bool clear;

  InitialFirebaseCrudState({this.clear});

}

class LoadingFirebaseCrudState extends FirebaseCrudState {}

class ClearFirebaseCrudState extends FirebaseCrudState {}

