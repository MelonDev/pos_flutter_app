part of 'firebase_crud_bloc.dart';

@immutable
abstract class FirebaseCrudState {}

class InitialFirebaseCrudState extends FirebaseCrudState {}

class LoadingFirebaseCrudState extends FirebaseCrudState {}

class ClearFirebaseCrudState extends FirebaseCrudState {}

