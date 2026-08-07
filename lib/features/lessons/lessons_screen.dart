import 'package:flutter/material.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/site_footer.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

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
              color: const Color(0xFFECEFF1),
              child: const Center(
                child: Text('Lessons Screen', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}
