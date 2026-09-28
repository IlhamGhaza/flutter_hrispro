import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/quick_stats_model.dart';

abstract class QuickStatsState {}

class QuickStatsInitial extends QuickStatsState {}
class QuickStatsLoading extends QuickStatsState {}
class QuickStatsLoaded extends QuickStatsState {
  final QuickStatsModel data;
  QuickStatsLoaded(this.data);
}
class QuickStatsError extends QuickStatsState {
  final String message;
  QuickStatsError(this.message);
}

class QuickStatsCubit extends Cubit<QuickStatsState> {
  QuickStatsCubit() : super(QuickStatsInitial());

  Future<void> fetchStats() async {
    emit(QuickStatsLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      emit(QuickStatsLoaded(
        QuickStatsModel(
          attendanceRate: '96.4%',
          leaveBalance: '12 days',
          pendingRequests: '2',
          upcomingHoliday: 'Jul 17',
        ),
      ));
    } catch (e) {
      emit(QuickStatsError(e.toString()));
    }
  }
}
