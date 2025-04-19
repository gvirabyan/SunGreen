import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../endpoints.dart';

class AddPlantScreen extends StatefulWidget {
  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  String selectedPlantType = 'aloe';
  final TextEditingController nameController = TextEditingController();
  final List<String> plantTypes = [
    'aloe',
    'cactus',
    'ficus',
    'sansevieria',
    'money tree',
  ];

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9EED9),
      appBar: AppBar(
        backgroundColor: Color(0xFFF9EED9),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Add plant',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E2E2E),
              ),
            ),
            SizedBox(height: 20),
            Text('Введите название растения:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFDDE7C7),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'example: monstera...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text('Выберите тип растения', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFDDE7C7),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                children: [

                  DropdownSearch<String>(
                    items: plantTypes,
                    selectedItem: plantTypes.contains(selectedPlantType) ? selectedPlantType : 'aloe',
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFDDE7C7),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF688C28), width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    popupProps: PopupProps.menu(
                      menuProps: MenuProps(
                        backgroundColor: Color(0xFFDDE7C7), // <-- Здесь цвет фона выпадающего меню
                      ),
                      showSearchBox: true,

                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          labelText: 'Поиск...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      itemBuilder: (context, item, isSelected) {
                        return ListTile(
                          title: Text(
                            item,
                            style: TextStyle(
                              color: selectedPlantType == item ? Color(0xFF688C28) : Colors.black,
                              fontWeight: selectedPlantType == item ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPlantType = newValue!;
                      });
                    },
                  )



                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Введите дату последнего полива',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFDDE7C7),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(16),
              child: InkWell(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Color(0xFF688C28),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedDate.day} ${_monthName(selectedDate.month)} ${selectedDate.year}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.calendar_today, size: 20),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (nameController.text.trim().isEmpty || selectedPlantType.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Заполните все поля')),
                    );
                    return;
                  }

                  try {
                    await  PlantApiService.addPlant(
                    name: nameController.text.trim(),
                    type: selectedPlantType,
                    lastWatered: selectedDate,
                    );

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('✅ Растение добавлено')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('❌ Ошибка при сохранении')),
                    );
                  }
                },
                child: Text('Сохранить', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF688C28),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];
    return months[month - 1];
  }
}
