import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_screen.dart';

openCameraView(BuildContext context) async {
  print("camera call");
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CameraScreen(camera: firstCamera)));
}
