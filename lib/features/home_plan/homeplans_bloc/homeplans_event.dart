part of 'homeplans_bloc.dart';

@immutable
sealed class HomeplansEvent {}

class GetAllHomeplansEvent extends HomeplansEvent {
  final Map<String, dynamic> params;

  GetAllHomeplansEvent({required this.params});
}

class GetAllHomeplanByIdEvent extends HomeplansEvent {
  final int homeplanID;

  GetAllHomeplanByIdEvent({required this.homeplanID});
}

class AddHomeplanEvent extends HomeplansEvent {
  final Map<String, dynamic> homeplanDetails;

  AddHomeplanEvent({required this.homeplanDetails});
}

class EditHomeplanEvent extends HomeplansEvent {
  final Map<String, dynamic> homeplanDetails;
  final int homeplanId;

  EditHomeplanEvent({
    required this.homeplanDetails,
    required this.homeplanId,
  });
}

class DeleteHomeplanEvent extends HomeplansEvent {
  final int homeplanId;

  DeleteHomeplanEvent({required this.homeplanId});
}

class GetAllCategoriesEvent extends HomeplansEvent {}

class DeleteFloorEvent extends HomeplansEvent {
  final int floorId;

  DeleteFloorEvent({required this.floorId});
}
