import 'package:flutter_bloc/flutter_bloc.dart';

class CorrectionCubit extends Cubit<bool> {
  CorrectionCubit() : super(false);
  void toggleForm(bool show) => emit(show);
}
