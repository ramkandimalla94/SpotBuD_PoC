import 'package:get/get.dart';
import 'package:spotbud/ui/viewmodels/auth_viewmodel.dart';

class NameViewModel extends GetxController {
  final AuthViewModel _authService = Get.find();

  Future<void> storeName(String firstName, String lastName) async {
    await _authService.storeName(firstName, lastName);
  }

  Future<void> signUp(
      String email, String password, String firstName, String lastName) async {
    try {
      // Sign up the user with email and password
      // ...

      // Store the user's name in Firestore
      // Replace 'userId' with the actual user ID obtained after signing up
      await _authService.storeUserName(userId, firstName, lastName);

      // Navigate to the trial screen
      Get.toNamed('/trial');
    } catch (e) {
      print("Error signing up: $e");
      // Handle sign-up error
    }
  }
}
