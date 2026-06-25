import 'package:flutter_bloc/flutter_bloc.dart';

enum CalendarMode { month, week }

class CalendarCubit extends Cubit<CalendarMode> {
  CalendarCubit() : super(CalendarMode.month);
  void setMode(CalendarMode mode) => emit(mode);
}
