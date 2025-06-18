import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../util/file_upload.dart';
import '../../../values/strings.dart';

part 'floors_event.dart';
part 'floors_state.dart';

class FloorsBloc extends Bloc<FloorsEvent, FloorsState> {
  FloorsBloc() : super(FloorsInitialState()) {
    on<FloorsEvent>((event, emit) async {
      try {
        emit(FloorsLoadingState());
        SupabaseQueryBuilder table =
            Supabase.instance.client.from('floor_plans');

        if (event is GetAllFloorsEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*');

          if (event.params['id'] != null) {
            query = query.eq('homeplan_id', event.params['id']);
          }

          if (event.params['query'] != null) {
            query = query.ilike('name', '%${event.params['query']}%');
          }

          List<Map<String, dynamic>> floors =
              await query.order('name', ascending: true);

          emit(FloorsGetSuccessState(floors: floors));
        } else if (event is AddFloorEvent) {
          event.floorDetails['image_url'] = await uploadFile(
            'floors/image',
            event.floorDetails['image'],
            event.floorDetails['image_name'],
          );
          event.floorDetails.remove('image');
          event.floorDetails.remove('image_name');

          await table.insert(event.floorDetails);

          emit(FloorsSuccessState());
        } else if (event is EditFloorEvent) {
          if (event.floorDetails['image'] != null) {
            event.floorDetails['image_url'] = await uploadFile(
              'floors/image',
              event.floorDetails['image'],
              event.floorDetails['image_name'],
            );
            event.floorDetails.remove('image');
            event.floorDetails.remove('image_name');
          }
          await table.update(event.floorDetails).eq('id', event.floorId);

          emit(FloorsSuccessState());
        } else if (event is DeleteFloorEvent) {
          await table.delete().eq('id', event.floorId);
          emit(FloorsSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(FloorsFailureState());
      }
    });
  }
}
