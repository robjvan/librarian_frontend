import 'package:get/get.dart';

class PasswordVisibiltyController extends GetxController {
  final RxBool _obscurePassword = true.obs;
  bool get obscurePassword => _obscurePassword.value;

  void toggleVisibility() {
    _obscurePassword.value = !_obscurePassword.value;
  }
}
