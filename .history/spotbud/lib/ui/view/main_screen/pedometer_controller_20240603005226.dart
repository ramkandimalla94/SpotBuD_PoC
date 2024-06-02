import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PedometerController extends GetxController {
  var steps = 0.obs;
  var dailySteps = 0.obs;
  var status = 'Unknown'.obs;

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  @override
  void onInit() {
    super.onInit();
    _requestPermissions();
    _loadDailySteps();
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
    _updateDailySteps(event.steps);
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

  Future<void> _loadDailySteps() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSavedDate = prefs.getString('lastSavedDate') ?? '';
    final today = DateTime.now().toIso8601String().split('T').first;

    if (lastSavedDate != today) {
      // Reset daily steps if it's a new day
      await prefs.setInt('dailySteps', 0);
      await prefs.setString('lastSavedDate', today);
    }

    dailySteps.value = prefs.getInt('dailySteps') ?? 0;
  }

  Future<void> _updateDailySteps(int totalSteps) async {
    final prefs = await SharedPreferences.getInstance();
    final initialSteps = prefs.getInt('initialSteps') ?? totalSteps;

    final todaySteps = totalSteps - initialSteps;
    dailySteps.value = todaySteps;

    await prefs.setInt('initialSteps', initialSteps);
    await prefs.setInt('dailySteps', todaySteps);
  }
}
