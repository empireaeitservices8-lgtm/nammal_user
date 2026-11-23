import 'dart:async';
import 'package:flutter/material.dart';

class VideoCallingScreen extends StatefulWidget {
  final String name;

  const VideoCallingScreen({super.key, this.name = 'Maya'});

  @override
  State<VideoCallingScreen> createState() => _VideoCallingScreenState();
}

class _VideoCallingScreenState extends State<VideoCallingScreen> {
  bool _isConnected = false;
  bool _isMuted = false;
  bool _isCameraOff = false;
  bool _isSpeakerOn = true;
  bool _isFrontCamera = true;
  Timer? _connectTimer;

  @override
  void initState() {
    super.initState();
    // After 3 seconds, transition to connected video call screen
    _connectTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isConnected = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _connectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full Screen Edge-to-Edge Video Image with smooth cross-fade
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Image.asset(
                _isConnected
                    ? 'assets/images/video_call_connected_screen.png'
                    : 'assets/images/maya_video_call_screen.png',
                key: ValueKey<bool>(_isConnected),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
              ),
            ),
          ),

          // Top Bar Overlay: Translucent Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),

          // ===================================================================
          // REAL BUTTONS OVERLAY - CALLING SCREEN (First 3 seconds)
          // ===================================================================
          if (!_isConnected)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 26,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 1. Red End Call Button
                  _buildCallingButton(
                    onTap: () => Navigator.of(context).pop(),
                    icon: Icons.call_end_rounded,
                    backgroundColor: const Color(0xFFDE1C24),
                    iconColor: Colors.white,
                    size: 64,
                    shadowColor: const Color(0x66DE1C24),
                  ),

                  // 2. Microphone Button
                  _buildCallingButton(
                    onTap: () {
                      setState(() {
                        _isMuted = !_isMuted;
                      });
                    },
                    icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    backgroundColor: _isMuted
                        ? Colors.white
                        : const Color(0xFFE5E5EA),
                    iconColor: _isMuted
                        ? const Color(0xFFDE1C24)
                        : Colors.black87,
                    size: 58,
                  ),

                  // 3. Camera Button
                  _buildCallingButton(
                    onTap: () {
                      setState(() {
                        _isCameraOff = !_isCameraOff;
                      });
                    },
                    icon: _isCameraOff
                        ? Icons.videocam_off_rounded
                        : Icons.camera_alt_rounded,
                    backgroundColor: _isCameraOff
                        ? Colors.white
                        : const Color(0xFFE5E5EA),
                    iconColor: _isCameraOff
                        ? const Color(0xFFDE1C24)
                        : Colors.black87,
                    size: 58,
                  ),

                  // 4. Speaker Button
                  _buildCallingButton(
                    onTap: () {
                      setState(() {
                        _isSpeakerOn = !_isSpeakerOn;
                      });
                    },
                    icon: _isSpeakerOn
                        ? Icons.volume_up_rounded
                        : Icons.volume_down_rounded,
                    backgroundColor: _isSpeakerOn
                        ? const Color(0xFFE5E5EA)
                        : Colors.white.withValues(alpha: 0.75),
                    iconColor: Colors.black87,
                    size: 58,
                  ),
                ],
              ),
            )
          // ===================================================================
          // REAL BUTTONS OVERLAY - CONNECTED SCREEN (After 3 seconds)
          // ===================================================================
          else
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 18,
              left: 18,
              right: 18,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row of 3 Secondary Actions: Video Off, Switch Camera, Chat
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       _buildSecondaryAction(
                  //         icon: _isCameraOff
                  //             ? Icons.videocam_off_rounded
                  //             : Icons.videocam_rounded,
                  //         label: 'Video Off',
                  //         isActive: _isCameraOff,
                  //         onTap: () {
                  //           setState(() {
                  //             _isCameraOff = !_isCameraOff;
                  //           });
                  //         },
                  //       ),
                  //       _buildSecondaryAction(
                  //         icon: Icons.flip_camera_ios_rounded,
                  //         label: 'Switch Camera',
                  //         isActive: !_isFrontCamera,
                  //         onTap: () {
                  //           setState(() {
                  //             _isFrontCamera = !_isFrontCamera;
                  //           });
                  //         },
                  //       ),
                  //       _buildSecondaryAction(
                  //         icon: Icons.chat_bubble_rounded,
                  //         label: 'Chat',
                  //         isActive: false,
                  //         onTap: () {
                  //           ScaffoldMessenger.of(context).showSnackBar(
                  //             const SnackBar(
                  //               content: Text('Opening chat with Maya...'),
                  //               duration: Duration(seconds: 1),
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 22),

                  // Bottom Pill Bar with 5 Live Controls
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xD82A2438),
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Mic Mute
                        _buildPillAction(
                          icon: _isMuted
                              ? Icons.mic_off_rounded
                              : Icons.mic_rounded,
                          color: _isMuted
                              ? const Color(0xFFDE1C24)
                              : Colors.white,
                          onTap: () {
                            setState(() {
                              _isMuted = !_isMuted;
                            });
                          },
                        ),

                        // Video Toggle
                        _buildPillAction(
                          icon: _isCameraOff
                              ? Icons.videocam_off_rounded
                              : Icons.videocam_rounded,
                          color: _isCameraOff
                              ? const Color(0xFFDE1C24)
                              : Colors.white,
                          onTap: () {
                            setState(() {
                              _isCameraOff = !_isCameraOff;
                            });
                          },
                        ),

                        // Central Red End Call Button
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDE1C24),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFDE1C24,
                                  ).withValues(alpha: 0.50),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.call_end_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),

                        // Flip Camera
                        _buildPillAction(
                          icon: Icons.sync_rounded,
                          color: Colors.white,
                          onTap: () {
                            setState(() {
                              _isFrontCamera = !_isFrontCamera;
                            });
                          },
                        ),

                        // Chat
                        // _buildPillAction(
                        //   icon: Icons.chat_outlined,
                        //   color: Colors.white,
                        //   onTap: () {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //         content: Text('Opening chat...'),
                        //         duration: Duration(seconds: 1),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Helper for Calling Screen circular buttons
  Widget _buildCallingButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required double size,
    Color? shadowColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? Colors.black.withValues(alpha: 0.20),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: size * 0.48),
      ),
    );
  }

  // Helper for Connected Screen bottom pill icon buttons
  Widget _buildPillAction({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
