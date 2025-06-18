part of 'floors_bloc.dart';

@immutable
sealed class FloorsEvent {}

class GetAllFloorsEvent extends FloorsEvent {
  final Map<String, dynamic> params;

  GetAllFloorsEvent({required this.params});
}

class AddFloorEvent extends FloorsEvent {
  final Map<String, dynamic> floorDetails;

  AddFloorEvent({required this.floorDetails});
}

class EditFloorEvent extends FloorsEvent {
  final Map<String, dynamic> floorDetails;
  final int floorId;

  EditFloorEvent({
    required this.floorDetails,
    required this.floorId,
  });
}

class DeleteFloorEvent extends FloorsEvent {
  final int floorId;

  DeleteFloorEvent({required this.floorId});
}
