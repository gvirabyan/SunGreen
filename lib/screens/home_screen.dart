import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled14/screens/plant_screen.dart';

import '../endpoints.dart';
import '../local_notificationService.dart';
import 'add_plant_screen.dart';
import 'models/plant.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Plant>> _plantsFuture;

  bool _shouldWater = false;

  @override
  void initState() {
    super.initState();
    _plantsFuture = PlantApiService.fetchPlants();
    LocalNotificationService.initialize();
    _checkWateringStatus();
  }

  void _checkWateringStatus() async {
    bool result = await PlantApiService.shouldWaterPlantsToday();
    setState(() {
      _shouldWater = result;
    });
    if (_shouldWater) {
      String plantName =
          'Монстера';
      LocalNotificationService.showNotificationWithPlantName(plantName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9EED9),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: AddPlantScreen(), // Здесь открываем экран как диалог
              );
            },
          );
          setState(() {
            _plantsFuture = PlantApiService.fetchPlants();
          });
        },
        backgroundColor: Color(0xFF688C28),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Поисковое поле
                TextField(
                  decoration: InputDecoration(
                    hintText: '    Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FutureBuilder<List<Plant>>(
                  future: _plantsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    // Если произошла ошибка
                    if (snapshot.hasError) {
                      return Center(child: Text('Ошибка: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Список растений пуст'));
                    }
                    final plants = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: plants.length,
                      itemBuilder: (context, index) {
                        final plant = plants[index];
                        if (plant.photoUrl != null) {
                          print(plant.photoUrl);
                        }
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child:
                                (plant.photoUrl != null &&
                                        plant.photoUrl!.isNotEmpty)
                                    ? Image.network(
                                      plant.photoUrl!,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Image.asset(
                                          'assets/plant.png',
                                          height: 200,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                    : Image.asset(
                                      'assets/plant.png',
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                          ),

                          title: Text(plant.name),
                          subtitle: Text(plant.type),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PlantScreen(
                                      plantId: plant.id,
                                      photoUrl: plant.photoUrl ?? '',
                                    ),
                              ),
                            );
                          },
                        );
                      },
                      physics: NeverScrollableScrollPhysics(),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 80,
            bottom: 5,
            child: Container(
              width: 30,
              child: ListView.builder(
                itemCount: 26,
                itemBuilder: (context, index) {
                  final letter = String.fromCharCode(65 + index); // A-Z
                  return InkWell(
                    onTap: () {
                      print('Tapped on $letter');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                      child: Text(
                        letter,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
