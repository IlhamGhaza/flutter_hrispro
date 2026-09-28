import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/today_summary_model.dart';

abstract class TodaySummaryState {}

class TodaySummaryInitial extends TodaySummaryState {}
class TodaySummaryLoading extends TodaySummaryState {}
class TodaySummaryLoaded extends TodaySummaryState {
  final TodaySummaryModel data;
  TodaySummaryLoaded(this.data);
}
class TodaySummaryError extends TodaySummaryState {
  final String message;
  TodaySummaryError(this.message);
}

class TodaySummaryCubit extends Cubit<TodaySummaryState> {
  TodaySummaryCubit() : super(TodaySummaryInitial());

  Future<void> fetchSummary() async {
    emit(TodaySummaryLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      emit(TodaySummaryLoaded(
        TodaySummaryModel(
          checkIn: '08:02',
          checkInStatus: 'On Time',
          checkOut: '17:15',
          checkOutStatus: 'On Time',
          workHours: '8h 13m',
          workHoursTotal: '9h total',
          overtime: '0h',
          overtimeStatus: 'Not yet',
        ),
      ));
    } catch (e) {
      emit(TodaySummaryError(e.toString()));
    }
  }
}
