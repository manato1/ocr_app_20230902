import 'dart:io';
import 'package:ocr_app_20230902/presentation/screens/ocr/ocr_result.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key});

  @override
  State<OcrScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<OcrScreen> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;

  late final Future<void> _future;
  CameraController? _cameraController;

  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (_isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(), //利用可能なカメラのリストを取得
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //フロントカメラを取得し開く
                    _initCameraController(snapshot.data!);
                    return Center(child: CameraPreview(_cameraController!));
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              appBar: AppBar(
                title: const Text('テキストスキャン'),
              ),
              backgroundColor: _isPermissionGranted ? Colors.transparent : null,
              body: _isPermissionGranted
                  //カメラ許可された
                  ? Column(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: _scanImage,
                              child: const Text('スキャン'),
                            ),
                          ),
                        ),
                      ],
                    )
                  //カメラ許可されていない
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: const Text(
                          'カメラへのアクセスが許可されていません',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // 最初のリアカメラを選択します
    CameraDescription? camera; //カメラの名前、レンズの向き、サポートされている解像度などの情報を提供します
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        //現在アクティブなカメラが背面カメラ（バックカメラ）であるかどうかをチェックしています
        camera = current;
        break;
      }
    }

    //フロントのカメラを取得したら取得したものでカメラスタート
    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max, // 解像度設定
      enableAudio: false,
    );

    await _cameraController!.initialize(); //カメラを開く
    await _cameraController!.setFlashMode(FlashMode.off); //ラッシュライトの状態を制御します

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    //カメラ開けていなけらばリターン
    if (_cameraController == null) return;

    final navigator = Navigator.of(context); //ページ遷移の下準備

    try {
      final pictureFile = await _cameraController!.takePicture(); //写真撮る

      final file = File(pictureFile.path); //Fileに変換

      final inputImage = InputImage.fromFile(file); //テキストスキャンできるよう変換
      final recognizedText = await textRecognizer.processImage(inputImage);
      // 撮影後、画面遷移して次のページへ値を渡す
      await navigator.push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              OcrResult(text: "スキャンしたテキスト"),
      // await navigator.push(
      //   MaterialPageRoute(
      //     builder: (BuildContext context) =>
      //         ResultScreen(text: recognizedText.text),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('スキャンに失敗しました'),
        ),
      );
    }
  }
}
