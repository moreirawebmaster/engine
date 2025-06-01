import 'package:camera/camera.dart';
import 'package:design_system/lib.dart';
import 'package:engine/lib.dart';
import 'package:flutter/material.dart';

class EngineBarcodeScannerWidget extends StatefulWidget {
  const EngineBarcodeScannerWidget({
    required this.service,
    required this.onBarcodeDetected,
    this.height = 0.4,
    this.width = 1.0,
    super.key,
  });

  final EngineBarcodeScannerService service;
  final Function(String barcode) onBarcodeDetected;
  final double height;
  final double width;

  @override
  State<EngineBarcodeScannerWidget> createState() => _EngineBarcodeScannerWidgetState();
}

class _EngineBarcodeScannerWidgetState extends MonitorableState<EngineBarcodeScannerWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final _) async {
      await _startCamera();
    });
  }

  Future<void> _startCamera() async {
    await widget.service.initialize();
    widget.service.setBarcodeHandler(widget.onBarcodeDetected);
    setStateSafely(() {});
  }

  @override
  Widget build(final BuildContext context) {
    if (widget.service.controller == null || !widget.service.isInitialized) {
      return Center(child: DsCircularLoading(native: false));
    }

    return SizedBox(
      height: widget.height * MediaQuery.of(context).size.height,
      width: widget.width * MediaQuery.of(context).size.width,
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: widget.service.controller!.value.previewSize!.height,
          height: widget.service.controller!.value.previewSize!.width,
          child: CameraPreview(widget.service.controller!),
        ),
      ),
    );
  }
}
