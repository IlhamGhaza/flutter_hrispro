import 'package:flutter_bloc/flutter_bloc.dart';

class CheckInCubit extends Cubit<int> {
  CheckInCubit() : super(0);
  void nextStep() => emit(state + 1);
  void prevStep() => emit(state - 1);
  void reset() => emit(0);
}
