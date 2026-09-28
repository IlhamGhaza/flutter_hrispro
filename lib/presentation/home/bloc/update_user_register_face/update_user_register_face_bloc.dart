import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_hrispro/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_hrispro/data/datasource/auth_local_datasource.dart';

import '../../../../data/model/response/user_response_model.dart';

part 'update_user_register_face_bloc.freezed.dart';
part 'update_user_register_face_event.dart';
part 'update_user_register_face_state.dart';

class UpdateUserRegisterFaceBloc
    extends Bloc<UpdateUserRegisterFaceEvent, UpdateUserRegisterFaceState> {
  final AuthRemoteDatasource authRemoteDatasource;
  UpdateUserRegisterFaceBloc(this.authRemoteDatasource)
    : super(const _Initial()) {
    on<_UpdateProfileRegisterFace>((event, emit) async {
      emit(const _Loading());
      try {
        final user = await authRemoteDatasource.updateProfileRegisterFace(
          event.embedding,
        );
        await user.fold((l) async => emit(_Error(l)), (r) async {
          // Save updated user data to local storage
          await AuthLocalDatasource().updateAuthData(r);
          emit(_Success(r));
        });
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}
