import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled14/screens/plant_screen.dart';

import '../endpoints.dart';
import 'add_plant_screen.dart';
import 'models/plant.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Plant>> _plantsFuture;

  @override
  void initState() {
    super.initState();
    _plantsFuture = PlantApiService.fetchPlants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFF9EED9),
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

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
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
                // Загрузка данных с API и отображение списка растений
                FutureBuilder<List<Plant>>(
                  future: _plantsFuture,
                  builder: (context, snapshot) {
                    // Пока данные загружаются
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    // Если произошла ошибка
                    if (snapshot.hasError) {
                      return Center(child: Text('Ошибка: ${snapshot.error}'));
                    }
                    // Если данных нет
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Список растений пуст'));
                    }
                    // Если данные успешно загружены
                    final plants = snapshot.data!;
                    print(plants.length);
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: plants.length,
                      itemBuilder: (context, index) {
                        final plant = plants[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Image.asset('assets/plant.png'),
                          ),
                          title: Text(plant.name),
                          subtitle: Text(plant.type),
                          onTap: (){
                           // print(plant.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlantScreen(plantId: plant.id,

                                ),
                              ),
                            );                           },
                        );
                      },
                        physics: NeverScrollableScrollPhysics()
                    );
                  },
                ),
              ],
            ),
          ),
          // Вертикальный алфавит справа
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
