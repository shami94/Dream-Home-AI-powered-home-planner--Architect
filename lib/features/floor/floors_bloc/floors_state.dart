part of 'floors_bloc.dart';

@immutable
sealed class FloorsState {}

final class FloorsInitialState extends FloorsState {}

final class FloorsLoadingState extends FloorsState {}

final class FloorsSuccessState extends FloorsState {}

final class FloorsGetSuccessState extends FloorsState {
  final List<Map<String, dynamic>> floors;

  FloorsGetSuccessState({required this.floors});
}

final class FloorsFailureState extends FloorsState {
  final String message;

  FloorsFailureState({this.message = apiErrorMessage});
}
