import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_hrispro/data/datasource/overtime_remote_datasource.dart';
import 'package:flutter_hrispro/data/model/response/overtime_response_model.dart';

part 'get_overtime_status_bloc.freezed.dart';
part 'get_overtime_status_event.dart';
part 'get_overtime_status_state.dart';

class GetOvertimeStatusBloc
    extends Bloc<GetOvertimeStatusEvent, GetOvertimeStatusState> {
  final OvertimeRemoteDatasource datasource;
  GetOvertimeStatusBloc(this.datasource) : super(const _Initial()) {
    on<_GetOvertimeStatus>((event, emit) async {
      emit(const _Loading());
      final result = await datasource.getOvertimeStatus();
      result.fold((l) => emit(_Error(l)), (r) => emit(_Loaded(r)));
    });
  }
}
