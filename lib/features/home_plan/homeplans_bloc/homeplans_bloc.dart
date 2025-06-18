import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../util/file_upload.dart';
import '../../../values/strings.dart';

part 'homeplans_event.dart';
part 'homeplans_state.dart';

class HomeplansBloc extends Bloc<HomeplansEvent, HomeplansState> {
  HomeplansBloc() : super(HomeplansInitialState()) {
    on<HomeplansEvent>((event, emit) async {
      try {
        emit(HomeplansLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;
        SupabaseQueryBuilder table = supabaseClient.from('home_plans');

        if (event is GetAllHomeplansEvent) {
          List<Map<String, dynamic>> homeplans =
              await supabaseClient.rpc("get_homeplans_with_counts", params: {
            'p_architect_user_id': supabaseClient.auth.currentUser!.id,
            'p_search': event.params['query'],
          });

          emit(HomeplansGetSuccessState(homeplans: homeplans));
        } else if (event is GetAllHomeplanByIdEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query = table
              .select(
                  '*,floors:floor_plans(*),category:categories(*),architect:architects(*)')
              .eq('id', event.homeplanID);

          Map<String, dynamic> homeplan =
              await query.order('name', ascending: true).single();

          emit(HomeplansGetByIdSuccessState(homeplan: homeplan));
        } else if (event is AddHomeplanEvent) {
          Map<String, dynamic> architect = await supabaseClient
              .from('architects')
              .select()
              .eq('user_id', supabaseClient.auth.currentUser!.id)
              .single();
          if (architect['status'] != 'Approved') {
            emit(HomeplansFailureState(message: 'Architect not approved'));
          } else {
            event.homeplanDetails['architect_user_id'] =
                supabaseClient.auth.currentUser!.id;
            event.homeplanDetails['image_url'] = await uploadFile(
              'homeplans/image',
              event.homeplanDetails['image'],
              event.homeplanDetails['image_name'],
            );
            event.homeplanDetails.remove('image');
            event.homeplanDetails.remove('image_name');

            Map homeplan =
                await table.insert(event.homeplanDetails).select('id').single();

            emit(AddHomeplanSuccessState(homeplanID: homeplan['id']));
          }
        } else if (event is EditHomeplanEvent) {
          if (event.homeplanDetails['image'] != null) {
            event.homeplanDetails['image_url'] = await uploadFile(
              'homeplans/image',
              event.homeplanDetails['image'],
              event.homeplanDetails['image_name'],
            );
            event.homeplanDetails.remove('image');
            event.homeplanDetails.remove('image_name');
          }
          await table.update(event.homeplanDetails).eq('id', event.homeplanId);

          emit(HomeplansSuccessState());
        } else if (event is DeleteHomeplanEvent) {
          await table.delete().eq('id', event.homeplanId);
          emit(HomeplansSuccessState());
        } else if (event is GetAllCategoriesEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              supabaseClient.from('categories').select('*');

          List<Map<String, dynamic>> categories =
              await query.order('name', ascending: true);

          emit(CategoriesGetSuccessState(categories: categories));
        } else if (event is DeleteFloorEvent) {
          await supabaseClient
              .from('floor_plans')
              .delete()
              .eq('id', event.floorId);
          emit(HomeplansSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(HomeplansFailureState());
      }
    });
  }
}
