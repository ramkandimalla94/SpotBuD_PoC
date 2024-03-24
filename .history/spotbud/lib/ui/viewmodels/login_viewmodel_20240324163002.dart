import 'package:get/get.dart';
import 'package:spotbud/core/models/login_model.dart';

class LoginViewModel extends GetxController {
  var email = ''.obs;
  var password = ''.obs;

  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;

  void login() {
    // Perform login logic here, e.g., sending data to a backend server
    LoginModel loginData =
        LoginModel(email: email.value, password: password.value);

    print('Login Data: $loginData');
  }
}
