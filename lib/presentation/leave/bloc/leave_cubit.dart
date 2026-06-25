import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveCubit extends Cubit<bool> {
  LeaveCubit() : super(false);
  void toggleForm(bool show) => emit(show);
}
