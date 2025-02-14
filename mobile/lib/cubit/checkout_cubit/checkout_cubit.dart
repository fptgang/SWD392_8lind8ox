import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutCubit extends Cubit<int> {
  CheckoutCubit() : super(0);

  void selectPaymentMethod(int methodIndex) {
    emit(methodIndex);
  }
}
