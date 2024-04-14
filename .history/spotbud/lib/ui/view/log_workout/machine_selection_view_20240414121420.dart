import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MachineSelectionScreen extends StatelessWidget {
  final MachineSelectionController controller =
      Get.put(MachineSelectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.acccentColor),
        title: Text(
          'Select Exercise',
          style: AppTheme.secondaryText(
              fontWeight: FontWeight.w500, color: AppColors.acccentColor),
        ),
        actions: [
          IconButton(
            onPressed: () => _showSearchBar(context),
            icon: Icon(Icons.search, color: AppColors.acccentColor),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExerciseDialog(context),
        backgroundColor: AppColors.acccentColor,
        child: Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(
            child: LoadingIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: controller.bodyParts.length,
            itemBuilder: (context, index) {
              final bodyPart = controller.bodyParts[index];
              final machines = controller.machinesByBodyPart[bodyPart] ?? [];
              return ExpansionTile(
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.acccentColor,
                ),
                title: Text(
                  bodyPart,
                  style: AppTheme.secondaryText(
                      size: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColors.acccentColor),
                ),
                children: machines
                    .map((machine) => ListTile(
                          title: Text(
                            machine,
                            style: AppTheme.secondaryText(
                                size: 20,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondaryColor),
                          ),
                          onTap: () {
                            Get.back(result: {
                              'bodyPart': bodyPart,
                              'machine': machine
                            });
                          },
                        ))
                    .toList(),
              );
            },
          );
        }
      }),
    );
  }

  void _showSearchBar(BuildContext context) {
    showSearch(
      context: context,
      delegate: MachineSearchDelegate(
        controller.machinesByBodyPart,
        controller.recentSearches,
      ),
    );
  }

  void _showAddExerciseDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    String? selectedBodyPart;
    String? selectedExerciseType;
    bool singleLegOrArm = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.acccentColor,
          title: Text(
            'Add Exercise',
            style: AppTheme.secondaryText(
                fontWeight: FontWeight.w500, color: AppColors.primaryColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: AppTheme.primaryText(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                        size: 20),
                  ),
                ),
                SizedBox(height: 8.0),
                DropdownButtonFormField<String>(
                  dropdownColor: AppColors.acccentColor,
                  value: selectedBodyPart,
                  decoration: InputDecoration(
                    labelText: 'Body Part',
                    labelStyle: AppTheme.primaryText(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                        size: 18),
                  ),
                  onChanged: (value) {
                    selectedBodyPart = value;
                  },
                  items: controller.bodyParts
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: AppTheme.primaryText(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                            size: 15),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 8.0),
                DropdownButtonFormField<String>(
                  dropdownColor: AppColors.acccentColor,
                  value: selectedExerciseType,
                  decoration: InputDecoration(
                    labelText: 'Exercise Type',
                    labelStyle: AppTheme.primaryText(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                        size: 18),
                  ),
                  onChanged: (value) {
                    selectedExerciseType = value;
                  },
                  items: [
                    'Strength: Weight Reps',
                    'Strength: Weight Time',
                    'Body Weight: Reps',
                    'Body Weight: Time',
                    'Cardio: Time, Distance, Kcal',
                    'Others'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: AppTheme.primaryText(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                            size: 15),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      'Single Leg/Single Arm',
                      style: AppTheme.primaryText(
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                          size: 18),
                    ),
                    SizedBox(width: 8.0),
                    Obx(() => Checkbox(
                          checkColor: AppColors.acccentColor,
                          activeColor: AppColors.primaryColor,
                          value: controller.singleLegOrArm.value,
                          onChanged: (value) {
                            controller.singleLegOrArm.value = value ?? false;
                          },
                        )),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: AppTheme.primaryText(
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                    size: 15),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    selectedBodyPart != null &&
                    selectedExerciseType != null) {
                  await controller.addCustomExercise(
                    nameController.text,
                    selectedBodyPart!,
                    selectedExerciseType!,
                    singleLegOrArm,
                  );
                  Navigator.of(context).pop();
                } else {
                  // Show an error message if any field is empty
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fill all fields.'),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: Text(
                'Save',
                style: AppTheme.primaryText(
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                    size: 18),
              ),
            ),
          ],
        );
      },
    );
  }
}

class MachineSearchDelegate extends SearchDelegate<String> {
  final Map<String, List<String>> machinesByBodyPart;
  final List<String> recentSearches;

  MachineSearchDelegate(this.machinesByBodyPart, this.recentSearches);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(
          Icons.clear,
          color: AppColors.acccentColor,
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(
        Icons.arrow_back,
        color: AppColors.acccentColor,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Your logic to display search results
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
    );
  }

  @override
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      // Display recent searches if the search bar is empty
      if (recentSearches.isEmpty) {
        return SizedBox
            .shrink(); // Display an empty container if no recent searches
      } else {
        return ListView.builder(
          itemCount: recentSearches.length,
          itemBuilder: (context, index) {
            final suggestion = recentSearches[index];
            return ListTile(
              tileColor: AppColors.primaryColor,
              title: Text(
                suggestion,
                style: AppTheme.secondaryText(
                    size: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryColor),
              ),
              onTap: () {
                _handleSelection(context, suggestion);
              },
            );
          },
        );
      }
    } else {
      // Display search results based on the query
      final List<String> suggestions = [];
      machinesByBodyPart.forEach((key, value) {
        suggestions.addAll(value);
      });

      final List<String> filteredSuggestions = suggestions
          .where((suggestion) =>
              suggestion.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return ListView.builder(
        itemCount: filteredSuggestions.length,
        itemBuilder: (context, index) {
          final suggestion = filteredSuggestions[index];
          return ListTile(
            tileColor: AppColors.primaryColor,
            title: Text(
              suggestion,
              style: AppTheme.secondaryText(
                  size: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryColor),
            ),
            onTap: () {
              _handleSelection(context, suggestion);
            },
          );
        },
      );
    }
  }

  void _handleSelection(BuildContext context, String suggestion) {
    // Close the search and return the selected suggestion
    close(context, suggestion);

    // Perform the same action as tapping on any machine
    final bodyPart = machinesByBodyPart.entries
        .firstWhere((entry) => entry.value.contains(suggestion))
        .key;
    Get.back(result: {'bodyPart': bodyPart, 'machine': suggestion});

    // Add to recent searches
    MachineSelectionController controller = Get.find();
    controller.addToRecentSearches(suggestion);
  }
}

class MachineSelectionController extends GetxController {
  var bodyParts = <String>[].obs;
  var machinesByBodyPart = <String, List<String>>{}.obs;
  var loading = false.obs;
  var singleLegOrArm = false.obs;
  var recentSearches = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
    _loadRecentSearches();
  }

  void _loadRecentSearches() {
    // Load recent searches from local storage
    final savedSearches = /* load from local storage */ [];
    recentSearches.assignAll(savedSearches as Iterable<String>);
  }

  void _saveRecentSearches() {
    // Save recent searches to local storage
    /* save recentSearches to local storage */
  }

  void _loadData() async {
    try {
      loading.value = true; // Start loading
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('data')
            .doc(currentUser.uid)
            .get();
        if (docSnapshot.exists) {
          final userData = docSnapshot.data();
          if (userData != null) {
            final customMachines = userData['customMachine'] as List<dynamic>;

            // Clear previous data
            bodyParts.clear();
            machinesByBodyPart.clear();

            // Process fetched data
            customMachines.forEach((customMachine) {
              final bodyPart = customMachine['bodypart'] as String;
              final machines = (customMachine['machine'] as List<dynamic>)
                  .map((machine) => machine['name'] as String)
                  .toList();

              if (!bodyParts.contains(bodyPart)) {
                bodyParts.add(bodyPart);
              }

              if (!machinesByBodyPart.containsKey(bodyPart)) {
                machinesByBodyPart[bodyPart] = [];
              }

              machinesByBodyPart[bodyPart]?.addAll(machines);
            });

            // Sort machines alphabetically
            machinesByBodyPart.forEach((key, value) {
              machinesByBodyPart[key]?.sort();
            });
          }
        }
      }

      loading.value = false; // Data loading complete
    } catch (e) {
      print('Error loading data: $e');
      loading.value = false; // Error occurred, stop loading
    }
  }

  Future<void> addCustomExercise(
    String name,
    String bodyPart,
    String exerciseType,
    bool singleLegOrArm,
  ) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Get the current data
        final docSnapshot = await FirebaseFirestore.instance
            .collection('data')
            .doc(currentUser.uid)
            .get();

        // Check if the document exists
        if (docSnapshot.exists) {
          // Get the current customMachine array
          List<dynamic> customMachines = docSnapshot.get('customMachine');

          // Find the index of the body part if it exists
          int bodyPartIndex = customMachines.indexWhere(
              (customMachine) => customMachine['bodypart'] == bodyPart);

          // If the body part already exists, add the custom exercise to it
          if (bodyPartIndex != -1) {
            customMachines[bodyPartIndex]['machine'].add({
              'name': name,
              'type': exerciseType,
              'Single': singleLegOrArm,
            });
          }
          // If the body part does not exist, create a new entry for it
          else {
            customMachines.add({
              'bodypart': bodyPart,
              'machine': [
                {
                  'name': name,
                  'type': exerciseType,
                  'Single': singleLegOrArm,
                }
              ]
            });
          }

          // Update the document with the modified customMachine array
          await FirebaseFirestore.instance
              .collection('data')
              .doc(currentUser.uid)
              .update({'customMachine': customMachines});

          // Reload data
          _loadData();
        }
      }
    } catch (e) {
      print('Error adding custom exercise: $e');
    }
  }

  void addToRecentSearches(String query) {
    if (!recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      // Limit the recent searches to, say, 5
      if (recentSearches.length > 5) {
        recentSearches.removeLast();
      }
      _saveRecentSearches();
    }
  }
}
