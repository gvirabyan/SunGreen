import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4D79F),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF3E3B4),
      body: const Center(
        child:Column(
          children: [
            SizedBox(height: 20,),

            Text(
              'History',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            SizedBox(height: 10,),
        Text(
        'Выбрать дату:',
        style: TextStyle(fontSize: 18, color: Colors.black),

      ),

          ],
        )
      ),
    );
  }
}
