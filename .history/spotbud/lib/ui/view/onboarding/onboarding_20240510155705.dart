import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
//  final List<Introduction> list = [
//     Introduction(
//       title: 'Welcome to SpotBuD',
//       subTitle: 'Your Personal Gym Companion',
//       imageUrl: AppAssets.tracker,
//       titleTextStyle: TextStyle(
//         color: AppColors.backgroundColor,
//         fontSize: 30,
//         fontWeight: FontWeight.bold,
//         letterSpacing: 1.2, // Add letter spacing for better readability
//         shadows: [
//           Shadow(
//             color:
//                 AppColors.acccentColor.withOpacity(0.3), // Add shadow for depth
//             offset: Offset(2, 2),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       subTitleTextStyle: TextStyle(
//         color: AppColors.acccentColor,
//         fontSize: 15,
//         fontWeight: FontWeight.w700,
//         letterSpacing: 0.8, // Add slight letter spacing
//         shadows: [
//           Shadow(
//             color: Colors.white.withOpacity(0.3), // Add shadow for depth
//             offset: Offset(1, 1),
//             blurRadius: 2,
//           ),
//         ],
//       ),
//       imageWidth: 400,
//       imageHeight: 300,
//     ),
//     Introduction(
//       title: 'Discover ✨',
//       subTitle: 'Amazing Features that Empower Your Fitness Journey',
//       imageUrl: AppAssets.stats,
//       titleTextStyle: TextStyle(
//         color: AppColors.backgroundColor,
//         fontSize: 30,
//         fontWeight: FontWeight.bold,
//         letterSpacing: 1.2, // Add letter spacing for better readability
//         shadows: [
//           Shadow(
//             color:
//                 AppColors.acccentColor.withOpacity(0.3), // Add shadow for depth
//             offset: Offset(2, 2),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       subTitleTextStyle: TextStyle(
//         color: AppColors.acccentColor,
//         fontSize: 15,
//         fontWeight: FontWeight.w700,
//         letterSpacing: 0.8, // Add slight letter spacing
//         shadows: [
//           Shadow(
//             color: Colors.white.withOpacity(0.3), // Add shadow for depth
//             offset: Offset(1, 1),
//             blurRadius: 2,
//           ),
//         ],
//       ),
//       imageHeight: 380,
//     ),
//     Introduction(
//       title: 'Get Started',
//       subTitle: 'Your Journey to Fitness Begins Here',
//       imageUrl: AppAssets.activity,
//       titleTextStyle: TextStyle(
//         color: AppColors.backgroundColor,
//         fontSize: 30,
//         fontWeight: FontWeight.bold,
//         letterSpacing: 1.2, // Add letter spacing for better readability
//         shadows: [
//           Shadow(
//             color:
//                 AppColors.acccentColor.withOpacity(0.3), // Add shadow for depth
//             offset: Offset(2, 2),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       subTitleTextStyle: TextStyle(
//         color: AppColors.acccentColor,
//         fontSize: 15,
//         fontWeight: FontWeight.w700,
//         letterSpacing: 0.8, // Add slight letter spacing
//         shadows: [
//           Shadow(
//             color: Colors.white.withOpacity(0.3), // Add shadow for depth
//             offset: Offset(1, 1),
//             blurRadius: 2,
//           ),
//         ],
//       ),
//       imageHeight: 400,
//     ),
//   ];
  final List<Map<String, dynamic>> onboardingData = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Welcome to SpotBuD',
      'subtitle': 'Your Personal Gym Companion',
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'Stay Organized',
      'subtitle': 'Keep track of your tasks and goals.',
    },
    {
      'image': 'assets/images/onboarding3.png',
      'title': 'Achieve Success',
      'subtitle': 'Reach new heights with MyApp.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                image: onboardingData[index]['image'],
                title: onboardingData[index]['title'],
                subtitle: onboardingData[index]['subtitle'],
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => buildDot(index),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_currentPage < onboardingData.length - 1) {
            _controller.nextPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          } else {
            // Navigate to the next screen or perform any action
          }
        },
        label: Text(
            _currentPage < onboardingData.length - 1 ? 'Next' : 'Get Started'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: _currentPage == index ? 20 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardingPage({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 200,
        ),
        SizedBox(height: 30),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
