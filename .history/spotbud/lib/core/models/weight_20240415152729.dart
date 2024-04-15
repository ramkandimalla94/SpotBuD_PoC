import 'package:get/get.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

final UserDataViewModel _userDataViewModel = Get.put(UserDataViewModel());
String _getDisplayWeightUnit() {
  return _userDataViewModel.isKgsPreferred.value ? 'kg' : 'lbs';
}
