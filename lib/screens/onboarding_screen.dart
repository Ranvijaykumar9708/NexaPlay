import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/nexaplay_logo.dart';
import '../widgets/tv_focusable.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Unlimited Movies, Web Series and More',
      'subtitle':
          'Watch your favorite blockbusters, trending series and original cinema anytime, anywhere on any device.',
      'icon': Icons.movie_filter_rounded,
      'color': Color(0xFF8B5CF6),
      'image':
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1200&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Stream on Your TV',
      'subtitle':
          'Enjoy a cinematic 4K HDR experience crafted specifically for Android TV, Google TV and Smart TVs with effortless D-Pad navigation.',
      'icon': Icons.tv_rounded,
      'color': Color(0xFF06B6D4),
      'image':
          'https://images.unsplash.com/photo-1593784991095-a205069470b6?w=1200&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Entertainment for Everyone',
      'subtitle':
          'Multi-profiles, parental control gates for kids, curated recommendations, and multi-language audio & captions.',
      'icon': Icons.family_restroom_rounded,
      'color': Color(0xFFD946EF),
      'image':
          'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=1200&auto=format&fit=crop&q=80',
    },
  ];

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onFinish();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTV = size.width > 700;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Background PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    slide['image'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.surface,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.background.withValues(alpha: 0.95),
                          AppTheme.background.withValues(alpha: 0.7),
                          AppTheme.background.withValues(alpha: 0.95),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isTV ? 680 : 340),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (slide['color'] as Color)
                                  .withValues(alpha: 0.2),
                              border: Border.all(
                                color: (slide['color'] as Color)
                                    .withValues(alpha: 0.6),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              slide['icon'] as IconData,
                              size: isTV ? 56 : 42,
                              color: slide['color'] as Color,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            slide['title'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: isTV ? 34 : 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            slide['subtitle'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: isTV ? 16 : 14,
                              height: 1.5,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Top Header (Logo + Skip)
          Positioned(
            top: 24,
            left: isTV ? 48 : 20,
            right: isTV ? 48 : 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const NexaPlayLogo(size: 34, fontSize: 20),
                TVFocusable(
                  onPressed: widget.onFinish,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    child: Text(
                      'Skip',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Controls (Dots & Action Button)
          Positioned(
            bottom: isTV ? 40 : 28,
            left: isTV ? 48 : 24,
            right: isTV ? 48 : 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Indicators
                Row(
                  children: List.generate(_slides.length, (idx) {
                    final isActive = _currentPage == idx;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 8),
                      width: isActive ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: isActive
                            ? AppTheme.primaryViolet
                            : Colors.white.withValues(alpha: 0.2),
                      ),
                    );
                  }),
                ),

                // Next or Get Started
                TVFocusable(
                  autoFocus: true,
                  onPressed: _nextPage,
                  borderRadius: BorderRadius.circular(10),
                  scaleFactor: 1.08,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTV ? 32 : 24,
                      vertical: isTV ? 14 : 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.brandGradient,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryPurple.withValues(alpha: 0.5),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      _currentPage == _slides.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: GoogleFonts.outfit(
                        fontSize: isTV ? 16 : 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
