import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../models/content_item.dart';
import '../../../viewmodels/app_providers.dart';
import '../../../widgets/tv_focusable.dart';

class AiVoiceModal extends ConsumerStatefulWidget {
  final Function(ContentItem) onSelectContent;
  final bool isTV;

  const AiVoiceModal({
    super.key,
    required this.onSelectContent,
    this.isTV = true,
  });

  @override
  ConsumerState<AiVoiceModal> createState() => _AiVoiceModalState();
}

class _AiVoiceModalState extends ConsumerState<AiVoiceModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  String _selectedMood = '';
  List<ContentItem> _aiResults = [];

  final List<Map<String, dynamic>> _moods = [
    {
      'label': '🔥 High Adrenaline Action',
      'query': 'action',
      'subtitle': 'Jawan, Animal, KGF 2, Extraction',
    },
    {
      'label': '😂 Feel-Good Desi Comedy',
      'query': 'comedy',
      'subtitle': 'Panchayat, Stree 2, Motu Patlu',
    },
    {
      'label': '🕵️ Dark Crime & Purvanchal Thriller',
      'query': 'thriller',
      'subtitle': 'Mirzapur, The Family Man',
    },
    {
      'label': '🧠 Mythological Sci-Fi & Speculative',
      'query': 'sci-fi',
      'subtitle': 'Kalki 2898 AD, Interstellar',
    },
    {
      'label': '❤️ Inspiring Real-Life Journey',
      'query': 'drama',
      'subtitle': '12th Fail, RRR',
    },
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _onSelectMood(Map<String, dynamic> mood) {
    setState(() {
      _selectedMood = mood['label'] as String;
      final q = (mood['query'] as String).toLowerCase();
      _aiResults = ref.read(catalogueProvider).where((c) {
        return c.genres.any((g) => g.toLowerCase().contains(q));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTV = widget.isTV;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(isTV ? 40 : 16),
      child: Container(
        constraints: BoxConstraints(maxWidth: isTV ? 680 : double.infinity),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppTheme.surface.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primaryViolet, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryPurple.withValues(alpha: 0.35),
              blurRadius: 30,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryPurple.withValues(alpha: 0.2),
                        ),
                        child: const Icon(Icons.mic,
                            color: AppTheme.primaryViolet, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NexaPlay AI Cinephile',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Smart TV Voice & Mood Recommendation Engine',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TVFocusable(
                    onPressed: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(16),
                    child: const Icon(Icons.close, color: Colors.white60, size: 20),
                  ),
                ],
              ),
              const Divider(color: Colors.white12, height: 28),

              // Animated Soundwave Visualizer
              Container(
                height: 54,
                alignment: Alignment.center,
                child: AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(14, (idx) {
                        final factor = (idx % 4 + 1) * 0.25;
                        final barHeight =
                            10 + (_waveController.value * 34 * factor);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 4,
                          height: barHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                              colors: [
                                AppTheme.primaryPurple,
                                AppTheme.accentCyan
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Say something like "कुछ मिर्ज़ापुर जैसा एक्शन दिखाओ" or select your mood:',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Mood Selector Chips
              Column(
                children: _moods.map((mood) {
                  final isSelected = _selectedMood == mood['label'];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TVFocusable(
                      onPressed: () => _onSelectMood(mood),
                      borderRadius: BorderRadius.circular(10),
                      scaleFactor: 1.04,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryPurple.withValues(alpha: 0.25)
                              : AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.accentCyan
                                : Colors.white12,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mood['label'] as String,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  mood['subtitle'] as String,
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.arrow_forward_ios,
                              color: isSelected
                                  ? AppTheme.accentCyan
                                  : Colors.white24,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // AI Results
              if (_aiResults.isNotEmpty) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'AI Recommended (${_aiResults.length} Titles):',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentCyan,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _aiResults.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = _aiResults[index];
                      return TVFocusable(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onSelectContent(item);
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppTheme.cardColor,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(item.posterUrl, fit: BoxFit.cover),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.black87,
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    item.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
