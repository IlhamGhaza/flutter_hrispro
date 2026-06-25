import 'package:flutter_bloc/flutter_bloc.dart';

enum HistoryTab { attendance, leave, overtime }

class HistoryCubit extends Cubit<HistoryTab> {
  HistoryCubit() : super(HistoryTab.attendance);
  void setTab(HistoryTab tab) => emit(tab);
}
