import 'package:flutter_bloc/flutter_bloc.dart';

class CoShareCubit extends Cubit<int> {
  CoShareCubit() : super(1); // initial seat count

  void increase() => emit(state + 1);

  void decrease() {
    if (state > 1) emit(state - 1);
  }
}
