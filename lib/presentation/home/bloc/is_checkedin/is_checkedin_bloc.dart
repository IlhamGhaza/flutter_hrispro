import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hrispro/presentation/home/models/absent_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_hrispro/data/datasource/attendance_remote_datasource.dart';

part 'is_checkedin_bloc.freezed.dart';
part 'is_checkedin_event.dart';
part 'is_checkedin_state.dart';

class IsCheckedinBloc extends Bloc<IsCheckedinEvent, IsCheckedinState> {
  final AttendanceRemoteDatasource datasource;
  IsCheckedinBloc(this.datasource) : super(const _Initial()) {
    on<_IsCheckedIn>((event, emit) async {
      emit(const _Loading());
      final result = await datasource.isCheckedin();
      result.fold(
        (l) => emit(_Error(l)),
        (r) =>
            emit(_Success(AbsentStatus(isCheckedin: r.$1, isCheckedout: r.$2))),
      );
    });
  }
}
