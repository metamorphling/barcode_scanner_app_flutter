import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:game_barcode_scanner/dialogs/db_item_not_found.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: CameraScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  BarcodeDetector _barcodeDetector;
  Timer _timer;
  bool _isBusy = false;

  Future<String> recognizeBarcode(FirebaseVisionImage image) async {
    final List<Barcode> barcodes = await _barcodeDetector.detectInImage(image);

    for (Barcode barcode in barcodes) {
      final Rect boundingBox = barcode.boundingBox;
      final List<Offset> cornerPoints = barcode.cornerPoints;
      final BarcodeValueType valueType = barcode.valueType;
      switch (valueType) {
        case BarcodeValueType.isbn:
          return barcode.displayValue;
          break;
        default:
          print("Barcode type $valueType");
          break;
      }
    }
  }

  Future<String> TakeBarcodePhoto() async {
    if (_isBusy) {
      return null;
    }
    _isBusy = true;
    final image = await _controller.takePicture();
    _isBusy = false;
    String barcode =
        await recognizeBarcode(FirebaseVisionImage.fromFile(File(image.path)));
    return barcode;
  }

  Future<void> Tick(Timer t) async {}

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    _barcodeDetector = FirebaseVision.instance.barcodeDetector();

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();

    // _timer = new Timer.periodic(const Duration(seconds: 1), Tick);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    _barcodeDetector.close();
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Show me barcode')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            String barcode = await TakeBarcodePhoto();
            if (null == barcode) {
              return;
            }
            print('barcode found $barcode');

            WidgetsBinding.instance
                .addPostFrameCallback((_) => dbItemNotFound(context, barcode));
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// // A widget that displays the picture taken by the user.
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;

//   const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Display the Picture')),
//       // The image is stored as a file on the device. Use the `Image.file`
//       // constructor with the given path to display the image.
//       body: Image.file(File(imagePath)),
//     );
//   }
// }
