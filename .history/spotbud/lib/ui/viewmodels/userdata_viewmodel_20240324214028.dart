import 'package:get/get.dart';

class NameViewModel extends GetxController {
  final AuthService _authService = Get.find();

  Future<void> storeName(String firstName, String lastName) async {
    await _authService.storeName(firstName, lastName);
  }
}
