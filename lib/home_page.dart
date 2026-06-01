import 'package:flutter/material.dart';
import 'package:productivity_log/apparel_log.dart';
import 'package:productivity_log/my_app_bar.dart';
import 'package:productivity_log/add_box_time_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        extraActions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBoxTimePage())
              );
            },
            tooltip: 'Add box times',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ApparelLogPage())
              );
            },
            tooltip: 'Apparel log',
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
