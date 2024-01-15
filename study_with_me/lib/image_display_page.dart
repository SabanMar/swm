import 'package:flutter/material.dart';

class ImageDisplayPage extends StatelessWidget {
  final List<Image> images;

  ImageDisplayPage({required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDEBDD),
        title: Text('Uploaded Photos'),
      ),
      body: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            width: 300,   // adjust the width based on your needs
            height: 300,  // adjust the height based on your needs
            child: images[index],
          );
        },
      ),
    );
  }
}
