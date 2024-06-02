import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PedometerController extends GetxController {
  var steps = 0.obs;
  var status = 'Unknown'.obs;

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  @override
  void onInit() {
    super.onInit();
    _requestPermissions();
  }

  void _requestPermissions() async {
    var permissionStatus = await Permission.activityRecognition.request();
    if (permissionStatus.isGranted) {
      _initializePedometer();
    } else {
      print('Permission denied: $permissionStatus');
    }
  }

  void _initializePedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;

    _stepCountStream.listen(_onStepCount).onError(_onStepCountError);
    _pedestrianStatusStream
        .listen(_onPedestrianStatusChanged)
        .onError(_onPedestrianStatusError);
  }

  void _onStepCount(StepCount event) {
    steps.value = event.steps;
  }

  void _onStepCountError(error) {
    print('Step Count Error: $error');
    steps.value = 0;
  }

  void _onPedestrianStatusChanged(PedestrianStatus event) {
    status.value = event.status;
  }

  void _onPedestrianStatusError(error) {
    print('Pedestrian Status Error: $error');
    status.value = 'Unknown';
  }
}
