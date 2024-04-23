import 'package:flutter/material.dart';

class ModelViewerWithBoundingBoxes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3D Model Viewer with Bounding Boxes'),
      ),
      body: Center(
        child: GestureDetector(
          onTapUp: (TapUpDetails details) {
            final tapPosition = details.localPosition;
            final selectedPart = detectSelectedBodyPart(tapPosition);
            if (selectedPart != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selected Body Part: $selectedPart'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: Container(
            height: 300,
            width: 300,
            color: Colors.grey[200],
            child: ModelViewer(
              src: 'assets/models/your_model.glb',
              alt: '3D Model',
              autoRotate: true,
              cameraControls: true,
            ),
          ),
        ),
      ),
    );
  }

  String? detectSelectedBodyPart(Offset tapPosition) {
    // Simulate body part detection based on tap position
    final Map<String, Rect> boundingBoxes = {
      'chest': Rect.fromLTWH(50, 50, 100, 100),
      'back': Rect.fromLTWH(150, 50, 100, 100),
      'triceps': Rect.fromLTWH(50, 150, 100, 100),
      'biceps': Rect.fromLTWH(150, 150, 100, 100),
      'abs': Rect.fromLTWH(50, 250, 100, 100),
      'arm': Rect.fromLTWH(150, 250, 100, 100),
      'legs': Rect.fromLTWH(250, 50, 100, 100),
      'shoulders': Rect.fromLTWH(250, 150, 100, 100),
    };

    for (MapEntry<String, Rect> entry in boundingBoxes.entries) {
      if (entry.value.contains(tapPosition)) {
        return entry.key;
      }
    }
    return null; // No body part detected
  }
}
