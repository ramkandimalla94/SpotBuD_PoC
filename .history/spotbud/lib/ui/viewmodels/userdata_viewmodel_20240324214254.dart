import 'package:get/get.dart';
import 'package:spotbud/ui/viewmodels/auth_viewmodel.dart';

class NameViewModel extends GetxController {
  final AuthViewModel _authService = Get.find();

  Future<void> storeName(String firstName, String lastName) async {
    await _authService.storeName(firstName, lastName);
  }
}
