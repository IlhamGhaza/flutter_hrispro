import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarEvent {
  final DateTime date;
  final String title;
  final String type; // 'national_holiday', 'company_holiday', 'company_event', 'attendance'

  CalendarEvent({
    required this.date,
    required this.title,
    required this.type,
  });
}

abstract class CalendarEventState {}

class CalendarEventInitial extends CalendarEventState {}
class CalendarEventLoading extends CalendarEventState {}
class CalendarEventLoaded extends CalendarEventState {
  final List<CalendarEvent> events;
  CalendarEventLoaded(this.events);
}
class CalendarEventError extends CalendarEventState {
  final String message;
  CalendarEventError(this.message);
}

class CalendarEventCubit extends Cubit<CalendarEventState> {
  CalendarEventCubit() : super(CalendarEventInitial());

  Future<void> fetchEvents(int month, int year) async {
    emit(CalendarEventLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      // Mock data according to unimplemented_api_specs.md
      final mockEvents = [
        CalendarEvent(date: DateTime(year, month, 17), title: 'Idul Adha', type: 'national_holiday'),
        CalendarEvent(date: DateTime(year, month, 25), title: 'Townhall Meeting Q2', type: 'company_event'),
        CalendarEvent(date: DateTime(year, month, 12), title: 'Company Outing', type: 'company_holiday'),
        
        // Mock some attendance dots for demonstration
        CalendarEvent(date: DateTime(year, month, 1), title: 'Present', type: 'attendance'),
        CalendarEvent(date: DateTime(year, month, 2), title: 'Present', type: 'attendance'),
        CalendarEvent(date: DateTime(year, month, 3), title: 'Present', type: 'attendance'),
        CalendarEvent(date: DateTime(year, month, 4), title: 'Present', type: 'attendance'),
        CalendarEvent(date: DateTime(year, month, 5), title: 'Present', type: 'attendance'),
      ];
      emit(CalendarEventLoaded(mockEvents));
    } catch (e) {
      emit(CalendarEventError(e.toString()));
    }
  }
}
