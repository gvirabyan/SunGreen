import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io'; // Для проверки платформы и версии

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsScreen> {
  bool airduino = false;
  bool geolocation = true;
  bool notifications = true;
  bool bluetoothConnected = false;

  FlutterBluePlus flutterBlue = FlutterBluePlus();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _checkLocationService();
    _checkBluetoothStatus();
  }

  Future<void> _checkPermissions() async {
    await _checkBluetoothPermissions();
    await _checkLocationPermission();
  }

  Future<void> _checkBluetoothPermissions() async {
    PermissionStatus bluetoothStatus = await Permission.bluetooth.status;
    if (!bluetoothStatus.isGranted) {
      PermissionStatus status = await Permission.bluetooth.request();
      if (status.isGranted) {
        print("Bluetooth permission granted");
      } else {
        print("Bluetooth permission denied");
      }
    }
  }

  Future<void> _checkLocationPermission() async {
    PermissionStatus locationStatus = await Permission.location.status;
    if (!locationStatus.isGranted) {
      PermissionStatus status = await Permission.location.request();
      if (status.isGranted) {
        print("Location permission granted");
      } else {
        print("Location permission denied");
      }
    }
  }

  Future<void> _checkLocationService() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      geolocation = isEnabled;
    });
  }

  Future<void> _checkBluetoothStatus() async {
    bool isAvailable = await FlutterBluePlus.isAvailable;
    bool isOn = await FlutterBluePlus.isOn;

    setState(() {
      bluetoothConnected = isAvailable && isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E9C9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.bluetooth, color: bluetoothConnected ? Colors.blue : Colors.red),
                  const SizedBox(width: 8),
                  const Text('Bluetooth'),
                  const Spacer(),
                  Text(
                    bluetoothConnected ? 'Подключено' : 'Не подключено',
                    style: TextStyle(color: bluetoothConnected ? Colors.green : Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildToggleTile(
                icon: Icons.all_inclusive,
                label: 'Airduino',
                value: airduino,
                onChanged: (val) => setState(() => airduino = val),
              ),
              const SizedBox(height: 16),
              _buildToggleTile(
                icon: Icons.location_on_outlined,
                label: 'Геолокация',
                value: geolocation,
                onChanged: (val) async {
                  if (val) {
                    LocationPermission permission = await Geolocator.checkPermission();
                    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
                      permission = await Geolocator.requestPermission();
                    }

                    bool isEnabled = await Geolocator.isLocationServiceEnabled();
                    if (!isEnabled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Геолокация отключена. Открываю настройки...')),
                      );
                      await Geolocator.openLocationSettings();
                      await Future.delayed(const Duration(seconds: 2));
                      _checkLocationService();
                    } else if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
                      setState(() => geolocation = val);
                    }
                  } else {
                    setState(() => geolocation = val);
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildToggleTile(
                icon: Icons.notifications_none,
                label: 'Уведомления',
                value: notifications,
                onChanged: (val) async {
                  if (val) {
                    // Проверка версии Android
                    if (Platform.isAndroid && (await _getAndroidVersion()) >= 13) {
                      PermissionStatus notificationStatus = await Permission.notification.status;
                      if (!notificationStatus.isGranted) {
                        PermissionStatus status = await Permission.notification.request();
                        if (status.isGranted) {
                          setState(() => notifications = true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Разрешение на уведомления отклонено')),
                          );
                          setState(() => notifications = false);
                        }
                      } else {
                        setState(() => notifications = true);
                      }
                    } else {
                      setState(() => notifications = true);
                    }
                  } else {
                    setState(() => notifications = false);
                  }
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'После подключения Bluetooth данные\nсобираются в фоне каждые 4 часа',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> _getAndroidVersion() async {
    try {
      String version = Platform.operatingSystemVersion;
      final match = RegExp(r'Android (\d+)').firstMatch(version);
      if (match != null && match.groupCount > 0) {
        return int.tryParse(match.group(1)!) ?? 0;
      }
    } catch (_) {}
    return 0;
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBD8AA),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 12),
          Text(label),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF475122),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
