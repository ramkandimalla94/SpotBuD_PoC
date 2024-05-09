import 'package:flutter/material.dart';
import 'package:human_body_selector/human_body_selector.dart';
import 'package:human_body_selector/svg_painter/maps.dart';

class Bodypart extends StatefulWidget {
  const Bodypart({super.key});

  @override
  State<Bodypart> createState() => _BodypartState();
}

class _BodypartState extends State<Bodypart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HumanBodySelector(
            map: Maps.HUMAN,
            onChanged: (bodyPart, active) {},
            onLevelChanged: (bodyPart) {},
            multiSelect: true,
            toggle: true,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width - 100,
          ),
        ],
      ),
    );
  }
}
