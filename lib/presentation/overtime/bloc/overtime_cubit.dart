import 'package:flutter_bloc/flutter_bloc.dart';

class OvertimeCubit extends Cubit<bool> {
  OvertimeCubit() : super(false);
  void toggleForm(bool show) => emit(show);
}
