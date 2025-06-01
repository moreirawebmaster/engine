import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:engine/lib.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class EngineBarcodeScannerService {
  CameraController? _controller;
  BarcodeScanner? _barcodeScanner;
  CameraDescription? _cameraDescription;
  bool _isInitialized = false;
  bool _isDetecting = false;
  int _frameCount = 0;

  final int _frameSkipCount = 5;
  final Duration _throttleDuration = const Duration(seconds: 1);
  DateTime _lastProcessed = DateTime.fromMillisecondsSinceEpoch(0);

  Function(String barcode) _onBarcodeDetected = (final barcode) {};

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;

  Future<void> initialize({final ResolutionPreset resolution = ResolutionPreset.high}) async {
    if (_isInitialized || _controller != null) {
      return;
    }

    EngineLog.debug('CameraController is initializing.');

    try {
      final cameras = await availableCameras();
      _cameraDescription = cameras.firstWhere(
        (final c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        _cameraDescription!,
        resolution,
        enableAudio: false,
      );

      _barcodeScanner = BarcodeScanner(
        formats: [BarcodeFormat.ean8, BarcodeFormat.ean13],
      );

      await _controller?.initialize();

      await _controller?.lockCaptureOrientation(DeviceOrientation.portraitUp);
    } catch (error, stackTrace) {
      _isInitialized = false;
      EngineLog.error('Error when initializing the camera.', error: error, stackTrace: stackTrace);
      rethrow;
    } finally {
      _isInitialized = true;
      EngineLog.debug('CameraController initialized.');
      await startStream();
    }
  }

  void setBarcodeHandler(final Function(String barcode) onBarcode) {
    _onBarcodeDetected = onBarcode;
  }

  Function(String barcode) getBarcodeHandler() => _onBarcodeDetected;

  Future<void> startStream() async {
    if (!_isInitialized) {
      EngineLog.debug('CameraController not initialized.');
      return;
    }

    if (_controller?.value.isStreamingImages == true) {
      EngineLog.debug('Stream already active.');
      return;
    }

    try {
      EngineLog.debug('Starting image stream.');
      await _controller?.startImageStream(_processImage);
    } on PlatformException catch (e) {
      if (e.message?.contains('No active stream to cancel') ?? false) {
        EngineLog.debug('Stream could not start: No active stream to cancel.');
      } else {
        EngineLog.error('Failed to start image stream.', error: e, stackTrace: StackTrace.current);
      }
    } catch (e, stack) {
      EngineLog.error('Unexpected error starting stream.', error: e, stackTrace: stack);
    }
  }

  Future<void> stopStream() async {
    if (_controller?.value.isStreamingImages == true) {
      EngineLog.debug('Stopping image stream.');
      await _controller?.stopImageStream();
      _isDetecting = false;
    }
  }

  Future<void> dispose() async {
    if (_isInitialized) {
      EngineLog.debug('Disposing barcode scanner service.');

      setBarcodeHandler((final barcode) {});

      try {
        await stopStream();
        await _controller?.dispose();
        await _barcodeScanner?.close();

        _controller = null;
        _barcodeScanner = null;
      } finally {
        _isInitialized = false;
      }
    }
  }

  Future<void> _processImage(final CameraImage image) async {
    if (_shouldSkipFrame) {
      return;
    }

    final now = DateTime.now();
    if (_isDetecting || now.difference(_lastProcessed) < _throttleDuration) {
      return;
    }

    _isDetecting = true;
    _lastProcessed = now;

    try {
      final inputImage = _cameraImageToInputImage(image);
      final barcodes = await _barcodeScanner?.processImage(inputImage);

      if (barcodes?.isNotEmpty == true) {
        final value = barcodes?.first.rawValue;
        if (value != null && value.isNotEmpty) {
          EngineLog.debug('Barcode scanned with success.', data: {'barcode': value});
          await _onBarcodeDetected.call(value);
        }
      }
    } catch (error, stackTrace) {
      EngineLog.error('Barcode detection failed.', error: error, stackTrace: stackTrace);
    } finally {
      _isDetecting = false;
    }
  }

  InputImage _cameraImageToInputImage(final CameraImage image) {
    final bytes = Platform.isAndroid && image.format.group == ImageFormatGroup.yuv420
        ? image.getNv21Uint8List()
        : _concatenatePlanes(
            image.planes,
          );
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final camera = _cameraDescription!;
    final rotation = _rotationFromSensorOrientation(camera.sensorOrientation);

    final inputImageFormat = Platform.isAndroid && image.format.group == ImageFormatGroup.yuv420
        ? InputImageFormat.nv21
        : InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;

    final metadata = InputImageMetadata(
      size: imageSize,
      rotation: rotation,
      format: inputImageFormat,
      bytesPerRow: image.planes.first.bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  InputImageRotation _rotationFromSensorOrientation(final int sensorOrientation) =>
      InputImageRotationValue.fromRawValue(sensorOrientation) ?? InputImageRotation.rotation0deg;

  static Uint8List _concatenatePlanes(final List<Plane> planes) {
    final allBytes = WriteBuffer();
    for (final plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  bool get _shouldSkipFrame {
    _frameCount++;

    if (_frameCount >= 1000) {
      _frameCount = 0;
    }

    return _frameCount % _frameSkipCount != 0;
  }
}

// Converts the yuv420 to nv21
//
// Flutter issue: https://github.com/flutter/flutter/issues/145961
// Android camera issue: https://issuetracker.google.com/issues/359664078?pli=1
//
// Exctracted from https://github.com/flutter/flutter/issues/145961#issuecomment-2337772272
extension _Nv21Converter on CameraImage {
  Uint8List getNv21Uint8List() {
    final width = this.width;
    final height = this.height;

    final yPlane = planes[0];
    final uPlane = planes[1];
    final vPlane = planes[2];

    final yBuffer = yPlane.bytes;
    final uBuffer = uPlane.bytes;
    final vBuffer = vPlane.bytes;

    final numPixels = (width * height * 1.5).toInt();
    final nv21 = List<int>.filled(numPixels, 0);

    // Full size Y channel and quarter size U+V channels.
    var idY = 0;
    var idUV = width * height;
    final uvWidth = width ~/ 2;
    final uvHeight = height ~/ 2;
    // Copy Y & UV channel.
    // NV21 format is expected to have YYYYVU packaging.
    // The U/V planes are guaranteed to have the same row stride and pixel stride.
    // getRowStride analogue??
    final uvRowStride = uPlane.bytesPerRow;
    // getPixelStride analogue
    final uvPixelStride = uPlane.bytesPerPixel ?? 0;
    final yRowStride = yPlane.bytesPerRow;
    final yPixelStride = yPlane.bytesPerPixel ?? 0;

    for (var y = 0; y < height; ++y) {
      final uvOffset = y * uvRowStride;
      final yOffset = y * yRowStride;

      for (var x = 0; x < width; ++x) {
        nv21[idY++] = yBuffer[yOffset + x * yPixelStride];

        if (y < uvHeight && x < uvWidth) {
          final bufferIndex = uvOffset + (x * uvPixelStride);
          //V channel
          nv21[idUV++] = vBuffer[bufferIndex];
          //V channel
          nv21[idUV++] = uBuffer[bufferIndex];
        }
      }
    }
    return Uint8List.fromList(nv21);
  }
}
