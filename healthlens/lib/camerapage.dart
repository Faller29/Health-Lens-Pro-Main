import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isPermissionGranted = false;

  // Aspect ratio variable (you can adjust this as needed)
  late double _aspectRatio;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndInitializeCamera();
  }

  Future<void> _checkPermissionsAndInitializeCamera() async {
    // Check for camera permissions
    PermissionStatus cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
    }

    if (cameraStatus.isGranted) {
      _isPermissionGranted = true;
      await _initializeCamera();
    } else {
      // Handle the case when the user denies the permission
      setState(() {
        _isPermissionGranted = false;
      });
    }
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(_cameras![0], ResolutionPreset.high);
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
        final size = MediaQuery.of(context).size;
        _aspectRatio = size.width / size.height;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: _isPermissionGranted
            ? _isCameraInitialized
                ? Center(
                    child: AspectRatio(
                      aspectRatio: _aspectRatio,
                      child: CameraPreview(_cameraController!),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )
            : Center(
                child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  'Camera permission denied. To use this feature, Turn on Camera Permission',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              )),
      ),
      Positioned(
        top: 100,
        right: 0,
        child: _isPermissionGranted
            ? _isCameraInitialized
                ? Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      14.0,
                      0.0,
                      14.0,
                      0.0,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 150.0,
                          height: 300.0,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            shape: BoxShape.rectangle,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(8.0, 14.0, 8.0, 14.0),
                                child: Text(
                                  "Ingredients Detected",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(8.0, 14.0, 8.0, 14.0),
                                child: Text(
                                  "Ingredients Detected",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => foodServing(),
                          child: Text(
                            'Eat Food',
                            style: GoogleFonts.outfit(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.4),
                            side: BorderSide(
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )
            : Center(
                child: Text(''),
              ),
      ),
      Positioned(
        width: MediaQuery.of(context).size.width,
        bottom: 100,
        child: _isPermissionGranted
            ? _isCameraInitialized
                ? Padding(
                    padding: EdgeInsets.fromLTRB(14.0, 0, 14.0, 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: null,
                            child: Text(
                              'Start Detecting',
                              style: GoogleFonts.outfit(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xff4b39ef),
                              foregroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          ElevatedButton(
                            onPressed: null,
                            child: Text(
                              'Clear Ingredients',
                              style: GoogleFonts.outfit(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 239, 57, 57),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )
            : Center(
                child: Text(''),
              ),
      ),
    ]);
  }

  Future<dynamic> foodServing() {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 18, 0, 10),
                  child: Text(
                    'Food Serving',
                    style: GoogleFonts.outfit(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [],
                )
              ],
            ));
      },
    );
  }
}
