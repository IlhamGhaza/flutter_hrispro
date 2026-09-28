import 'package:bloc/bloc.dart';
import 'package:flutter_hrispro/data/datasource/user_remote_datasource.dart';
import 'package:flutter_hrispro/data/model/request/user_request_model.dart';
import 'package:flutter_hrispro/data/model/response/auth_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_bloc.freezed.dart';
part 'update_user_event.dart';
part 'update_user_state.dart';

class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserState> {
  final UserRemoteDatasource datasource;
  UpdateUserBloc(this.datasource) : super(_Initial()) {
    on<_UpdateUser>((event, emit) async {
      emit(_Loading());

      final result = await datasource.updateProfile(event.model, event.id);
      result.fold((l) => emit(_Error(l)), (r) => emit(_Success(r)));
    });
  }
}
