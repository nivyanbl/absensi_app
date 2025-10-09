import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenericInfoPage extends StatelessWidget {
  final String title;
  final String body;

  const GenericInfoPage({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(body),
      ),
    );
  }
}
