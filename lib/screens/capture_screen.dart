import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CaptureScreen extends StatefulWidget {
  final VoidCallback? onBack;

  /// Kept for compatibility with main.dart.
  /// In this updated version, this is used as "retake/clear current image",
  /// not system camera launch.
  final VoidCallback? onTakePhoto;

  final void Function(String?)? onCapture;
  final VoidCallback? onUploadImage;
  final File? selectedImage;

  const CaptureScreen({
    super.key,
    this.onBack,
    this.onTakePhoto,
    this.onCapture,
    this.onUploadImage,
    this.selectedImage,
  });

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _cameraInitFuture;
  XFile? _capturedImage;

  bool _isCapturing = false;
  bool _flashEnabled = false;
  String? _cameraError;

  bool get _hasSelectedImage => widget.selectedImage != null;
  bool get _hasCapturedImage => _capturedImage != null;
  bool get _hasImage => _hasSelectedImage || _hasCapturedImage;

  File? get _previewImage {
    if (widget.selectedImage != null) return widget.selectedImage;
    if (_capturedImage != null) return File(_capturedImage!.path);
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cameraInitFuture = _initializeCamera();
  }

  @override
  void didUpdateWidget(covariant CaptureScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When parent clears selectedImage, return to live camera preview.
    if (oldWidget.selectedImage != widget.selectedImage && widget.selectedImage == null) {
      setState(() => _capturedImage = null);
      if (_controller == null || !_controller!.value.isInitialized) {
        _cameraInitFuture = _initializeCamera();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      cameraController.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _cameraInitFuture = _initializeCamera();
      if (mounted) setState(() {});
    }
  }

  Future<void> _initializeCamera() async {
    try {
      setState(() => _cameraError = null);

      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        setState(() => _cameraError = 'No camera found on this device.');
        return;
      }

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      _controller = controller;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() => _cameraError = 'Camera failed to open.');
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _toggleFlash() async {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) return;

    final nextValue = !_flashEnabled;

    // Update the icon immediately so it is visibly clickable even on laptop/emulator previews.
    if (mounted) {
      setState(() {
        _flashEnabled = nextValue;
      });
    }

    try {
      await controller.setFlashMode(
        nextValue ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      debugPrint('Flash toggle error: $e');
    }
  }

  Future<void> _takePhoto() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized ||
        _isCapturing ||
        controller.value.isTakingPicture) {
      return;
    }

    setState(() => _isCapturing = true);

    try {
      try {
        await controller.setFlashMode(
          _flashEnabled ? FlashMode.torch : FlashMode.off,
        );
      } catch (_) {}

      final file = await controller.takePicture();

      if (!mounted) return;

      setState(() {
        _capturedImage = file;
      });
    } catch (e) {
      debugPrint('Take photo error: $e');
    } finally {
      if (mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
    });

    widget.onTakePhoto?.call();
  }

  void _analyzeImage() {
    final image = _previewImage;
    if (image == null) return;

    widget.onCapture?.call(image.path);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _CaptureBackground(),
          const _SoftCircle(top: -90, left: -70, size: 260, opacity: .28),
          const _SoftCircle(top: 95, right: -95, size: 220, opacity: .16),
          const _SoftCircle(bottom: -90, right: -80, size: 250, opacity: .22),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
              child: Column(
                children: [
                  _appBar(context),
                  const SizedBox(height: 6),

                  Flexible(
                    flex: 0,
                    child: _tipsCard(),
                  ),

                  const SizedBox(height: 6),

                  Expanded(
                    child: _preview(),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.camera_alt_rounded,
                          title: _hasImage ? 'Analyze Image' : 'Take Photo',
                          subtitle: _hasImage ? 'Analyze now' : 'Capture now',
                          filled: true,
                          onTap: _hasImage ? _analyzeImage : _takePhoto,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _ActionButton(
                          icon: _hasImage
                              ? Icons.refresh_rounded
                              : Icons.file_upload_outlined,
                          title: _hasImage ? 'Retake Photo' : 'Upload',
                          subtitle: _hasImage ? 'Capture again' : 'Choose photo',
                          filled: false,
                          onTap: _hasImage ? _retakePhoto : widget.onUploadImage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: GestureDetector(
                  onTap: widget.onBack ?? () => Navigator.maybePop(context),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.38),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(.62),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF06245C),
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Text(
            'Nail Capture',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: Color(0xFF071F55),
              letterSpacing: -.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tipsCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: _glassDecoration(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF086BFF),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'For better scan results:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF086BFF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 9),
              Row(
                children: [
                  Expanded(
                    child: _TipItem(
                      icon: Icons.center_focus_strong_rounded,
                      label: 'Center\nthe nail',
                    ),
                  ),
                  _DividerLine(),
                  Expanded(
                    child: _TipItem(
                      icon: Icons.wb_sunny_outlined,
                      label: 'Use even\nlighting',
                    ),
                  ),
                  _DividerLine(),
                  Expanded(
                    child: _TipItem(
                      icon: Icons.remove_red_eye_outlined,
                      label: 'Keep nail\nclearly visible',
                    ),
                  ),
                  _DividerLine(),
                  Expanded(
                    child: _TipItem(
                      icon: Icons.pan_tool_alt_outlined,
                      label: 'Hold still for\n1 second',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _preview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.16),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(.9), width: 1.8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF006CFF).withOpacity(.16),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: _previewContent(),
                ),
                const _NailGuideOverlay(),
                const Positioned(
                  bottom: 34,
                  child: _GuideInstructionLabel(),
                ),
                const _CornerGuides(),
                if (!_hasImage)
                  Positioned(
                    top: 24,
                    right: 28,
                    child: _FlashIconButton(
                      isOn: _flashEnabled,
                      onTap: _toggleFlash,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _previewContent() {
    final image = _previewImage;

    if (image != null) {
      return _CapturedNailPreview(image: image);
    }

    if (_cameraError != null) {
      return Container(
        color: const Color(0xFFB7DCFF),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Text(
          _cameraError!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF071F55),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }

    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return FutureBuilder<void>(
        future: _cameraInitFuture,
        builder: (context, snapshot) {
          return const _CameraLoadingPlaceholder();
        },
      );
    }

    return _CroppedCameraPreview(controller: controller);
  }

  BoxDecoration _glassDecoration(double radius) {
    return BoxDecoration(
      color: Colors.white.withOpacity(.62),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.white.withOpacity(.9), width: 1.4),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF0B6BFF).withOpacity(.12),
          blurRadius: 26,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }
}


class _CapturedNailPreview extends StatelessWidget {
  final File image;

  const _CapturedNailPreview({required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            image,
            fit: BoxFit.cover,
          ),

          // After capture, zoom into the center area where the nail guide is placed.
          // Live camera stays normal; only the captured preview is enlarged.
          Transform.scale(
            scale: 2.15,
            alignment: Alignment.center,
            child: Image.file(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}


class _FlashIconButton extends StatelessWidget {
  final bool isOn;
  final VoidCallback onTap;

  const _FlashIconButton({
    required this.isOn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: Icon(
            isOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
            color: Colors.white,
            size: 23,
            shadows: const [
              Shadow(
                color: Color(0xAA000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CroppedCameraPreview extends StatelessWidget {
  final CameraController controller;

  const _CroppedCameraPreview({required this.controller});

  @override
  Widget build(BuildContext context) {
    final previewSize = controller.value.previewSize;

    if (previewSize == null) {
      return CameraPreview(controller);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final previewWidth = previewSize.height;
        final previewHeight = previewSize.width;

        return ClipRect(
          child: OverflowBox(
            alignment: Alignment.center,
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: previewWidth,
                height: previewHeight,
                child: CameraPreview(controller),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CameraLoadingPlaceholder extends StatelessWidget {
  const _CameraLoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD8EDFF),
            Color(0xFFB7DCFF),
            Color(0xFF8EC7FF),
          ],
        ),
      ),
      child: const Center(
        child: SizedBox(
          width: 34,
          height: 34,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TipItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F3FF).withOpacity(.95),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF086BFF),
            size: 21,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10.2,
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: Color(0xFF071F55),
          ),
        ),
      ],
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.4,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: const Color(0xFFB9D9FF).withOpacity(.9),
    );
  }
}

class _GuideInstructionLabel extends StatelessWidget {
  const _GuideInstructionLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2D4A).withOpacity(.78),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Text(
        'Place one nail inside this guide',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _NailGuideOverlay extends StatelessWidget {
  const _NailGuideOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _NailGuidePainter(),
        child: Container(),
      ),
    );
  }
}

class _NailGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final guideWidth = size.width * .28;
    final guideHeight = size.height * .46;

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * .52),
        width: guideWidth,
        height: guideHeight,
      ),
      Radius.circular(guideWidth / 2),
    );

    final paint = Paint()
      ..color = Colors.white.withOpacity(.95)
      ..strokeWidth = 3.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CornerGuides extends StatelessWidget {
  const _CornerGuides();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CornerGuidePainter(),
      child: Container(),
    );
  }
}

class _CornerGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const corner = 34.0;
    const inset = 20.0;

    canvas.drawLine(
      const Offset(inset, inset + corner),
      const Offset(inset, inset + 10),
      paint,
    );
    canvas.drawLine(
      const Offset(inset, inset),
      const Offset(inset + corner, inset),
      paint,
    );

    canvas.drawLine(
      Offset(size.width - inset - corner, inset),
      Offset(size.width - inset, inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset + 10),
      Offset(size.width - inset, inset + corner),
      paint,
    );

    canvas.drawLine(
      Offset(inset, size.height - inset - corner),
      Offset(inset, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(inset, size.height - inset),
      Offset(inset + corner, size.height - inset),
      paint,
    );

    canvas.drawLine(
      Offset(size.width - inset - corner, size.height - inset),
      Offset(size.width - inset, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, size.height - inset - corner),
      Offset(size.width - inset, size.height - inset),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool filled;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: filled ? null : Colors.white.withOpacity(.88),
          gradient: filled
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF29A8FF),
                    Color(0xFF006DFF),
                    Color(0xFF0051D9),
                  ],
                )
              : null,
          border: Border.all(
            color: Colors.white.withOpacity(.9),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF006DFF).withOpacity(filled ? .34 : .12),
              blurRadius: filled ? 24 : 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: filled ? Colors.white : const Color(0xFF086BFF),
              size: 22,
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.6,
                      fontWeight: FontWeight.w900,
                      color: filled ? Colors.white : const Color(0xFF086BFF),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.2,
                      fontWeight: FontWeight.w700,
                      color: filled
                          ? Colors.white.withOpacity(.86)
                          : const Color(0xFF627493),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaptureBackground extends StatelessWidget {
  const _CaptureBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFDCEBFF),
            Color(0xFFBFDFFF),
            Color(0xFF88C4FF),
            Color(0xFF5EACFF),
          ],
          stops: [0.0, .38, .76, 1.0],
        ),
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final double opacity;

  const _SoftCircle({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(opacity),
              Colors.white.withOpacity(opacity * .45),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
