import 'package:flutter/material.dart';

class ImageDisplayPage extends StatelessWidget {
  final List<Image> images;

  ImageDisplayPage({required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uploaded Photos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: images,
        ),
      ),
    );
  }
}