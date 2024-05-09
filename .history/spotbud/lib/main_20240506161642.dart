import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotbud/firebase_options.dart';
import 'package:spotbud/routes/route_configure.dart';
import 'package:spotbud/routes/route_error.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(UserDataViewModel());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        ScreenUtil.init(
          context,
          designSize: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
          ),
        );
        return GetMaterialApp(
          theme: ThemeData(primaryColor: AppColors.acccentColor),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          unknownRoute:
              GetPage(name: '/route_error', page: () => const RouteErrorView()),
          getPages: AppRoutes.pages,
        );
      },
    );
  }
}
