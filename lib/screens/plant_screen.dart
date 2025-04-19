import 'package:flutter/material.dart';
import 'package:untitled14/screens/change_photo_screen.dart';
import 'package:untitled14/screens/diagnostics_screen.dart';
import 'package:untitled14/screens/history_screen.dart';
import 'package:untitled14/screens/models/plant_details.dart';
import 'package:untitled14/widgets/custom_app_bar.dart';
import '../endpoints.dart';

class PlantScreen extends StatefulWidget {
  final String plantId;
  final String photoUrl;

  const PlantScreen({super.key, required this.plantId, required this.photoUrl});

  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  PlantDetails? details;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPlantDetails();
  }

  Future<void> loadPlantDetails() async {
    try {
      final data = await PlantApiService.plantDetails(widget.plantId);
      setState(() {
        details = data;
        isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки деталей: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'title',
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF3E3B4),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : details == null
              ? const Center(child: Text('Ошибка загрузки данных'))
              : SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),

                    const SizedBox(height: 20),

                    (widget.photoUrl.isNotEmpty)
                        ? Image.network(
                          widget.photoUrl,
                          height: 200,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
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

                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF314D36),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            details!.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            details!.type,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    details?.lastSensorData?.humidity != null
                                        ? '${details!.lastSensorData!.humidity}%'
                                        : '—',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'humidity',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    details?.lastSensorData?.soilMoisture !=
                                            null
                                        ? '${details!.lastSensorData!.soilMoisture}%'
                                        : '—',

                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'soil humidity',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    details?.lastSensorData?.temperature != null
                                        ? '${details!.lastSensorData!.temperature}°C'
                                        : '—',

                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'temperature',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    details?.lastSensorData?.light != null
                                        ? '${details!.lastSensorData!.light}'
                                        : '—',

                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'light',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    details?.lastSensorData?.gasQuality != null
                                        ? '${details!.lastSensorData!.gasQuality}'
                                        : '—',

                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'gas quality',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Последная дата полива: ',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                details?.lastWatered?.toString() ?? '—',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Следующая дата полива: ',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                details?.nextWatering?.toString() ?? '—',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6E7C1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Рекомендация последняя от Gemini\n'
                              'Abyssinian Banana requires abundant, bright and direct light.\n'
                              'Place it less than one foot from a window to ensure it receives enough light to survive.',
                              style: const TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ChangePhotoScreen(
                                      plantId: widget.plantId,
                                      photoUrl: widget.photoUrl,
                                    ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 3,
                            ),
                            backgroundColor: const Color(0xFFF4D79F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5, // как у Container
                          ),
                          child: Text(
                            'Обновить фото',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DiagnosticsScreen(
                                      plantId:
                                          '7a240153-f8f2-43bd-839b-ff479d855abb',
                                    ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 3,
                            ),
                            backgroundColor: const Color(0xFFF4D79F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5, // как у Container
                          ),
                          child: Text(
                            'Диагностика',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        HistoryScreen(plantId: widget.plantId),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 3,
                            ),
                            backgroundColor: const Color(0xFFF4D79F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5, // как у Container
                          ),
                          child: Text(
                            'История',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
