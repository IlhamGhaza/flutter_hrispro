import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsCubit extends Cubit<String> {
  NotificationsCubit() : super('All');
  void setCat(String cat) => emit(cat);
}
