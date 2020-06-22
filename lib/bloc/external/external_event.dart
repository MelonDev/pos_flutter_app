part of 'external_bloc.dart';

@immutable
abstract class ExternalEvent {}

class InitialExternalEvent extends ExternalEvent {
  InitialExternalEvent();
}

class OpenScannerExternalEvent extends ExternalEvent {
  OpenScannerExternalEvent();
}
