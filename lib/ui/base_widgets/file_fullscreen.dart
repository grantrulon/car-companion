import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';

/* 
Widget that displays a file in an inspectible mode
- Currently, this is only about to display an image in a zoom in/out manner
*/
class FileFullscreen extends ConsumerWidget {
  const FileFullscreen({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.arrow_back))),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
          child: PhotoView(
        imageProvider: NetworkImage(url),
      )),
    );
  }
}
