import 'package:flutter/material.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/footer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              width: double.infinity,
              color: Colors.blueGrey[50],
              child: const Center(
                child: Text('About Virtual Begena', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
