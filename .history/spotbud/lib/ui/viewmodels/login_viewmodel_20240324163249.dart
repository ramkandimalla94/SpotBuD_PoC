import 'package:get/get.dart';
import 'package:spotbud/ui/models/login_model.dart';

class LoginViewModel extends GetxController {
  var email = ''.obs;
  var password = ''.obs;

  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;

  void login() {
    // Perform login logic here, e.g., sending data to a backend server
    LoginModel loginData =
        LoginModel(email: email.value, password: password.value);
    // Simulating a successful login
    // Replace this with your actual login logic, e.g., calling an API
    bool isLoggedIn = true; // Change to false if login fails

    if (isLoggedIn) {
      // If login is successful, navigate to '/trial' screen
      Get.offNamed(
          '/trial'); // This will replace the current route with '/trial'
      // If you want to keep the login screen in the navigation stack, use Get.toNamed('/trial');
    } else {
      // Handle login failure, e.g., show an error message
      Get.snackbar(
        'Login Failed',
        'Invalid email or password',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
