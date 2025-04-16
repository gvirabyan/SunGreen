import 'package:flutter/material.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFF9EED9),
      body: const Center(
        child:Column(
          children: [
            SizedBox(height: 20,),
            Text('Profile Settings ',style: TextStyle(color: Colors.black,fontSize: 30),),
          ],
        )
      ),
    );
  }
}
