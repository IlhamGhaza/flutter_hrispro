import 'package:flutter_bloc/flutter_bloc.dart';

class ApprovalCubit extends Cubit<Map<int, String>> {
  ApprovalCubit() : super({});

  void handleRequest(int id, String status) {
    final newState = Map<int, String>.from(state);
    newState[id] = status;
    emit(newState);
  }
}
