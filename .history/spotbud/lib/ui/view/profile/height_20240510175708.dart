import 'package:flutter/material.dart';

class HeightSettingScreen extends StatefulWidget {
  @override
  _HeightSettingScreenState createState() => _HeightSettingScreenState();
}

class _HeightSettingScreenState extends State<HeightSettingScreen> {
  int feet = 0;
  int inches = 0;
  double heightMeters = 0.0; // Updated to double
  int heightCentimeters = 0;

  bool _useFeetAndInches = true; // Default to using feet and inches

  void updatePreview() {
    setState(() {
      if (_useFeetAndInches) {
        int totalInches = feet * 12 + inches;
        heightMeters = totalInches * 0.0254;
        heightCentimeters = (heightMeters * 100).toInt();
      } else {
        double totalInches = heightMeters * 39.3701;
        feet = (totalInches / 12).floor();
        inches = (totalInches % 12).floor();
        heightCentimeters = (heightMeters * 100).toInt();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Height'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Height Unit:'),
                DropdownButton<bool>(
                  value: _useFeetAndInches,
                  onChanged: (bool? value) {
                    setState(() {
                      _useFeetAndInches = value!;
                      updatePreview(); // Update the preview when changing units
                    });
                  },
                  items: [
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text('Feet & Inches'),
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text('Meters & Centimeters'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Height:'),
            _useFeetAndInches
                ? Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Feet'),
                          onChanged: (value) {
                            setState(() {
                              feet = int.tryParse(value) ?? 0;
                              updatePreview(); // Update the preview when entering new values
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Inches'),
                          onChanged: (value) {
                            setState(() {
                              inches = int.tryParse(value) ?? 0;
                              updatePreview(); // Update the preview when entering new values
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Preview:'),
                          Text(
                              '${heightMeters.toStringAsFixed(2)} meters ${heightCentimeters} centimeters'),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Meters'),
                          onChanged: (value) {
                            setState(() {
                              heightMeters = double.tryParse(value) ?? 0;
                              updatePreview(); // Update the preview when entering new values
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Centimeters'),
                          onChanged: (value) {
                            setState(() {
                              heightCentimeters = int.tryParse(value) ?? 0;
                              updatePreview(); // Update the preview when entering new values
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Preview:'),
                          Text('${feet} feet ${inches} inches'),
                        ],
                      ),
                    ],
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Process the height data here, you can save it or perform other actions
                // For example, print the selected height based on the unit
                if (_useFeetAndInches) {
                  print('Height: $feet feet $inches inches');
                } else {
                  print(
                      'Height: $heightMeters meters $heightCentimeters centimeters');
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
