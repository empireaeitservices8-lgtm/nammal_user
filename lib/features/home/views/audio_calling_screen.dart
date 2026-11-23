import 'dart:async';
import 'package:flutter/material.dart';

class AudioCallingScreen extends StatefulWidget {
  final String name;
  final String age;
  final String location;
  final String matchedTime;
  final String imageUrl;

  const AudioCallingScreen({
    super.key,
    this.name = 'Sophie',
    this.age = '24',
    this.location = 'Brooklyn, NY',
    this.matchedTime = 'Matched 3d ago',
    this.imageUrl =
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=600&auto=format&fit=crop&q=80',
  });

  @override
  State<AudioCallingScreen> createState() => _AudioCallingScreenState();
}

class _AudioCallingScreenState extends State<AudioCallingScreen>
    with SingleTickerProviderStateMixin {
  bool _isConnected = false;
  bool _isMuted = false;
  bool _isSpeakerOn = true;
  // Start connected timer at 4:20 (260 seconds) to match the exact design, then increment
  int _callSeconds = 260;
  Timer? _connectTimer;
  Timer? _durationTimer;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for avatar concentric rings
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // After exactly 3 seconds of "Calling...", switch to Connected Screen
    _connectTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isConnected = true;
        });
        _startDurationTimer();
      }
    });
  }

  void _startDurationTimer() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _callSeconds++;
        });
      }
    });
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _connectTimer?.cancel();
    _durationTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3EFFF), Color(0xFFEDE8FA), Color(0xFFE5DCF7)],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _isConnected
                ? _buildConnectedScreen(context)
                : _buildCallingScreen(context),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. CALLING SCREEN (First 3 seconds - Exact match to Image 1)
  // ===========================================================================
  Widget _buildCallingScreen(BuildContext context) {
    return Column(
      key: const ValueKey('calling_screen'),
      children: [
        const SizedBox(height: 12),
        // Top Bar: Down Chevron, "End-to-End Encrypted", Equalizer Bars
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircleButton(
                icon: Icons.keyboard_arrow_down_rounded,
                iconColor: const Color(0xFF28233C),
                iconSize: 28,
                onTap: () => Navigator.of(context).pop(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6A4CEB).withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      color: Color(0xFF7047EB),
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'End-to-End Encrypted',
                      style: TextStyle(
                        color: Color(0xFF38334D),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              _buildCircleButton(
                customChild: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 3.5,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF28233C),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 2.5),
                      Container(
                        width: 3.5,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF28233C),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 2.5),
                      Container(
                        width: 3.5,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF28233C),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const Spacer(flex: 3),

        // Avatar with concentric rings
        _buildAvatar(withMicBadge: false),

        const SizedBox(height: 36),

        // Name & Location Info: "Sophie, 24"
        Text(
          '${widget.name}, ${widget.age}',
          style: const TextStyle(
            color: Color(0xFF1D1737),
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: 0.6,
              child: const Icon(
                Icons.navigation_rounded,
                color: Color(0xFF7047EB),
                size: 14,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              widget.location,
              style: const TextStyle(
                color: Color(0xFF696381),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '•',
                style: TextStyle(
                  color: Color(0xFF9892AB),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              widget.matchedTime,
              style: const TextStyle(
                color: Color(0xFF696381),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        // "Calling..." pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6A4CEB).withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            'Calling...',
            style: TextStyle(
              color: Color(0xFF5E3CE6),
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // HD Audio subtext
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF8E88A4), width: 1.2),
                borderRadius: BorderRadius.circular(3.5),
              ),
              child: const Text(
                'HD',
                style: TextStyle(
                  color: Color(0xFF6B6582),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'HD Audio  •  Ultra–low Latency',
              style: TextStyle(
                color: Color(0xFF7E7896),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const Spacer(flex: 4),

        // Red Cancel Button + "Cancel" text
        Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: const Color(0xFFDE1C24),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDE1C24).withValues(alpha: 0.45),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.call_end_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF645E7A),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),
      ],
    );
  }

  // ===========================================================================
  // 2. CONNECTED SCREEN (After 3s - Exact match to uploaded Image 2)
  // ===========================================================================
  Widget _buildConnectedScreen(BuildContext context) {
    final timerText = _formatDuration(_callSeconds);

    return Column(
      key: const ValueKey('connected_screen'),
      children: [
        const SizedBox(height: 12),
        // Top Bar: Down Chevron, Green Dot + "04:20" + Lock Pill, Purple Speaker Icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircleButton(
                icon: Icons.keyboard_arrow_down_rounded,
                iconColor: const Color(0xFF28233C),
                iconSize: 28,
                onTap: () => Navigator.of(context).pop(),
              ),

              // Active Call Timer Capsule: ● 04:20 🔒
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6A4CEB).withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timerText,
                      style: const TextStyle(
                        color: Color(0xFF28233C),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.lock_rounded,
                      color: Color(0xFF7047EB),
                      size: 13,
                    ),
                  ],
                ),
              ),

              // Top-Right Speaker Button (Purple Icon)
              _buildCircleButton(
                icon: _isSpeakerOn
                    ? Icons.volume_up_rounded
                    : Icons.volume_down_rounded,
                iconColor: const Color(0xFF7047EB),
                iconSize: 20,
                onTap: () {
                  setState(() {
                    _isSpeakerOn = !_isSpeakerOn;
                  });
                },
              ),
            ],
          ),
        ),

        const Spacer(flex: 3),

        // Avatar with concentric rings + Mic Badge on bottom right!
        _buildAvatar(withMicBadge: true),

        const SizedBox(height: 34),

        // Name: "Sophie" (Bold, no age)
        Text(
          widget.name,
          style: const TextStyle(
            color: Color(0xFF1D1737),
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle: "04:20  •  Brooklyn, NY"
        Text(
          '$timerText  •  ${widget.location}',
          style: const TextStyle(
            color: Color(0xFF696381),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),

        const Spacer(flex: 5),

        // Floating Bottom Island Pill with [Mute, End Call, Speaker]
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 22),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(44),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6A4CEB).withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Mute Button (Soft grey/lavender circle with mic icon)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isMuted = !_isMuted;
                  });
                },
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _isMuted
                        ? const Color(0xFFFFECEC)
                        : const Color(0xFFF1EDFD),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    color: _isMuted
                        ? const Color(0xFFDE1C24)
                        : const Color(0xFF28233C),
                    size: 24,
                  ),
                ),
              ),

              // End Call Button (Vibrant red glowing circle)
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDE1C24),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDE1C24).withValues(alpha: 0.45),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                        spreadRadius: 1,
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

              // Speaker Button (Soft purple circle with purple speaker icon)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSpeakerOn = !_isSpeakerOn;
                  });
                },
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _isSpeakerOn
                        ? const Color(0xFFE2D9FC)
                        : const Color(0xFFECE6FE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isSpeakerOn
                        ? Icons.volume_up_rounded
                        : Icons.volume_down_rounded,
                    color: const Color(0xFF7047EB),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),
      ],
    );
  }

  // ===========================================================================
  // REUSABLE COMPONENTS
  // ===========================================================================

  Widget _buildCircleButton({
    IconData? icon,
    Color? iconColor,
    double iconSize = 24,
    Widget? customChild,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6A4CEB).withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: customChild ?? Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }

  Widget _buildAvatar({required bool withMicBadge}) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Outer Concentric Thin Ring
            Container(
              width: 260 * _pulseAnimation.value,
              height: 260 * _pulseAnimation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF8B77FF).withValues(alpha: 0.35),
                  width: 1.2,
                ),
              ),
            ),

            // Middle Subtle Ring
            Container(
              width: 216 * _pulseAnimation.value,
              height: 216 * _pulseAnimation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF8B77FF).withValues(alpha: 0.20),
                  width: 1.0,
                ),
              ),
            ),

            // Main Avatar with White Border & Elevation
            Container(
              width: 154,
              height: 154,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6A4CEB).withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/audio_call_connected.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),

            // White Circle Mic Badge at bottom-right (Exact match to connected image)
            if (withMicBadge)
              Positioned(
                bottom: 4,
                right: 6,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mic_rounded,
                    color: Color(0xFF7047EB),
                    size: 18,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
