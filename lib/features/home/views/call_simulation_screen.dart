import 'dart:async';
import 'package:flutter/material.dart';

enum CallType { audio, video }

class CallSimulationScreen extends StatefulWidget {
  final CallType callType;

  const CallSimulationScreen({super.key, required this.callType});

  @override
  State<CallSimulationScreen> createState() => _CallSimulationScreenState();
}

class _CallSimulationScreenState extends State<CallSimulationScreen> {
  bool _isConnected = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Show first image for 3 seconds then switch to second image
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isConnected = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _currentImage {
    if (widget.callType == CallType.audio) {
      return _isConnected
          ? 'assets/images/audio_call_connected.png'
          : 'assets/images/audio_call_calling.png';
    } else {
      return _isConnected
          ? 'assets/images/video_call_connected.png'
          : 'assets/images/video_call_calling.png';
    }
  }

  Color get _backgroundColor {
    return widget.callType == CallType.audio
        ? const Color(0xFFEDE6FB)
        : const Color(0xFF1B1824);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Full Screen Call Image with smooth transition
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Image.asset(
                  _currentImage,
                  key: ValueKey<String>(_currentImage),
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

            // Top-left Back / Dismiss target
            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0x33000000),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),

            // End Call tap detection area at the bottom
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              height: 120,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
