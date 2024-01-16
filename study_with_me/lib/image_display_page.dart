import 'package:flutter/material.dart';

class ImageDisplayPage extends StatelessWidget {
  final List<Image> images;

  ImageDisplayPage({required this.images});

  @override
  Widget build(BuildContext context) {
    print('Number of images: ${images.length}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDEBDD),
        title: Text('Uploaded Photos'),
      ),
      body: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0), // Adjust the padding as needed
            child: Container(
              // adjust the height based on your needs
              child: images[index],
            ),
          );
        },
      ),
    );
  }
}
