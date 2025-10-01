import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Duration minDuration;
  const SplashScreen({Key? key, this.minDuration = const Duration(seconds: 7)}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  late final Animation<double> _pulse = Tween(begin: 0.95, end: 1.05).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

  late final AnimationController _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();

  String _title = '';
  final String _fullTitle = 'siestaclick';

  @override
  void initState() {
    super.initState();
    _startTypewriter();
  }

  void _startTypewriter() {
    int i = 0;
    Timer.periodic(const Duration(milliseconds: 120), (t) {
      if (i >= _fullTitle.length) {
        t.cancel();
        return;
      }
      setState(() => _title += _fullTitle[i]);
      i++;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB8E6C8), Color(0xFF6EA07A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _pulse,
                child: Container(
                  width: size.width * 0.32,
                  height: size.width * 0.32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 8))],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        'assets/image/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => Container(color: Colors.green, child: const Icon(Icons.check, size: 72, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _title,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.1),
              ),
              const SizedBox(height: 6),
              Opacity(
                opacity: 0.95,
                child: Text(
                  'smart attendance, simple life',
                  style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.95)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
