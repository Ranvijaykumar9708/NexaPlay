import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class NexaPlayLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool showTagline;
  final double fontSize;

  const NexaPlayLogo({
    super.key,
    this.size = 38,
    this.showText = true,
    this.showTagline = false,
    this.fontSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Glowing App Icon
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.28),
            gradient: const LinearGradient(
              colors: [Color(0xFF2E0854), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPurple.withValues(alpha: 0.35),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
            border: Border.all(
              color: AppTheme.primaryViolet.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Center(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFD946EF), Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Icon(
                Icons.play_arrow_rounded,
                size: size * 0.72,
                color: Colors.white,
              ),
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.25),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Nexa',
                      style: GoogleFonts.outfit(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    TextSpan(
                      text: 'Play',
                      style: GoogleFonts.outfit(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFC084FC),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (showTagline)
                Text(
                  'Your Cinema. Your Screen.',
                  style: GoogleFonts.outfit(
                    fontSize: fontSize * 0.42,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
