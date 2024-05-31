import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'dart:io';

import 'package:spotbud/ui/widgets/text.dart';

class TrainersZone extends StatefulWidget {
  const TrainersZone({super.key});

  @override
  _MyTrainerState createState() => _MyTrainerState();
}

class _MyTrainerState extends State<TrainersZone> {
  String? _imageUrl;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    User? user = _auth.currentUser;
    try {
      if (user != null) {
        String userId = user.uid;
        // Replace 'user_id' with the actual user's ID
        final userDoc = await FirebaseFirestore.instance
            .collection('data')
            .doc(userId)
            .get();
        setState(() {
          _imageUrl = userDoc['profile_image'];
        });
      }
    } catch (e) {
      print('Error fetching user image: $e');
    }
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(file);

        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _imageUrl = downloadUrl;
        });

        // Save the download URL to Firestore (or Realtime Database)

        FirebaseFirestore.instance.collection('data').doc(userId).update({
          'profile_image': downloadUrl,
        });
      }
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickAndUploadImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickAndUploadImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Trainers Profile",
          style: AppTheme.primaryText(
            size: 27,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: AppColors.black, // Adjust the back button color here
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                    child:
                        _imageUrl == null ? Icon(Icons.person, size: 50) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () => _showImageSourceActionSheet(context),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[200],
                        child: Icon(
                          Icons.edit,
                          size: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
