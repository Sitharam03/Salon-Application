import 'package:flutter/material.dart';
import 'dart:math' as math;

class SalonBackgroundAnimation extends StatefulWidget {
  const SalonBackgroundAnimation({super.key});

  @override
  State<SalonBackgroundAnimation> createState() => _SalonBackgroundAnimationState();
}

class _SalonBackgroundAnimationState extends State<SalonBackgroundAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // Expanded list of Salon & Spa relevant icons
  final List<IconData> _icons = [
    // Hair Care & Styling
    Icons.content_cut, // Scissors
    Icons.brush, // Brush
    Icons.face_retouching_natural, // Model/Face
    Icons.air, // Dryer/Air
    Icons.waves, // Hair waves
    
    // Tools & Supplies
    Icons.content_paste, // Clipboard/Pad
    Icons.colorize, // Dropper/Dye
    Icons.invert_colors, // Liquids/Oils
    Icons.sanitizer, // Bottles/Shampoo
    
    // Furniture & Equipment
    Icons.chair, // Styling Chair
    Icons.weekend, // Lounge/Waiting Chair
    Icons.bed, // Spa Bed
    Icons.wb_incandescent, // Lamps/Lighting
    
    // Spa & Skincare
    Icons.spa, // Lotus/Wellness
    Icons.hot_tub, // Steam/Bath
    Icons.dry_cleaning, // Towels
    Icons.clean_hands, // Hygiene/Wash
    Icons.soap, // Soap bar
    
    // Misc
    Icons.girl, // Lady icon
    Icons.star_border, // Sparkle
    Icons.diamond_outlined, // Premium/Luxury
  ];

  final List<_FloatingIcon> _floatingIcons = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Base duration, independent of particle speed
    )..repeat();

    // Spawn more icons for a fuller effect
    for (int i = 0; i < 25; i++) {
      _floatingIcons.add(_generateFloatingIcon(startRandomY: true));
    }
  }

  _FloatingIcon _generateFloatingIcon({bool startRandomY = false}) {
    return _FloatingIcon(
      icon: _icons[_random.nextInt(_icons.length)],
      x: _random.nextDouble(),
      y: startRandomY ? _random.nextDouble() : 1.1, // Start below screen if not randomY
      size: 20 + _random.nextDouble() * 40, // 20 - 60
      speed: 0.0005 + _random.nextDouble() * 0.0015, // Slow, gentle drift
      opacity: 0.05 + _random.nextDouble() * 0.15, // 0.05 - 0.20
      rotationSpeed: (_random.nextDouble() - 0.5) * 0.01,
      angle: _random.nextDouble() * 2 * math.pi,
      waveOffset: _random.nextDouble() * 2 * math.pi, // Random start phase
      waveAmplitude: 0.05 + _random.nextDouble() * 0.1, // Horizontal sway amount
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _BackgroundPainter(_floatingIcons, _generateFloatingIcon),
          size: Size.infinite,
        );
      },
    );
  }
}

class _FloatingIcon {
  IconData icon;
  double x; // 0.0 to 1.0 (Horizontal center of wave)
  double y; // 0.0 to 1.0
  double size;
  double speed;
  double opacity;
  double rotationSpeed;
  double angle;
  
  // Wave properties
  double waveOffset;
  double waveAmplitude;
  double currentX = 0; // Actual calculated X position

  _FloatingIcon({
    required this.icon,
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.rotationSpeed,
    required this.angle,
    required this.waveOffset,
    required this.waveAmplitude,
  });

  // Returns true if icon should be respawned
  bool update() {
    y -= speed;
    angle += rotationSpeed;
    
    // Calculate sine wave horizontal movement
    // Use y as time factor for consistent wave along height
    currentX = x + math.sin((y * 10) + waveOffset) * (waveAmplitude * 0.2); 
    
    return y < -0.2; // Respawn when well above screen
  }
}

class _BackgroundPainter extends CustomPainter {
  final List<_FloatingIcon> icons;
  final _FloatingIcon Function() respawnCallback;

  _BackgroundPainter(this.icons, this.respawnCallback);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < icons.length; i++) {
      var icon = icons[i];
      
      // Update logic inside paint loop for frame-by-frame animation
      if (icon.update()) {
        icons[i] = respawnCallback(); // Respawn if off screen
        icon = icons[i];
      }

      // Calculate fade at top and bottom edges
      double fade = 1.0;
      if (icon.y > 0.85) fade = (1.0 - icon.y) / 0.15; // Fade in at bottom
      if (icon.y < 0.15) fade = icon.y / 0.15; // Fade out at top
      
      if (fade < 0) fade = 0;
      if (fade > 1) fade = 1;

      final textPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon.icon.codePoint),
          style: TextStyle(
            fontSize: icon.size,
            fontFamily: icon.icon.fontFamily,
            color: Colors.black.withOpacity(icon.opacity * fade),
            package: icon.icon.fontPackage,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      canvas.save();
      final dx = icon.currentX * size.width;
      final dy = icon.y * size.height;
      
      canvas.translate(dx, dy);
      canvas.rotate(icon.angle);
      canvas.translate(-textPainter.width / 2, -textPainter.height / 2);
      
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
