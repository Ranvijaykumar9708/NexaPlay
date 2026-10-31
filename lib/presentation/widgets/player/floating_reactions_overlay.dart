import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/watch_party_viewmodel.dart';
import '../../../widgets/tv_focusable.dart';

class FloatingReactionsOverlay extends ConsumerWidget {
  final bool isTV;

  const FloatingReactionsOverlay({
    super.key,
    this.isTV = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchPartyVm = ref.watch(watchPartyProvider);
    final reactions = watchPartyVm.activeReactions;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // 1. Floating Animated Reactions Stream
        ...reactions.map((r) {
          return Positioned(
            left: size.width * r.xOffset,
            bottom: isTV ? 160 : 120,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 2200),
              builder: (context, val, child) {
                return Transform.translate(
                  offset: Offset(0, -val * 240),
                  child: Opacity(
                    opacity: (1.0 - val).clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: 1.0 + (val * 0.4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(r.emoji, style: const TextStyle(fontSize: 26)),
                            const SizedBox(width: 4),
                            Text(
                              r.sender,
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),

        // 2. D-pad Accessible Reaction Bar
        if (watchPartyVm.isInParty)
          Positioned(
            right: isTV ? 48 : 16,
            bottom: isTV ? 120 : 90,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: AppTheme.primaryViolet.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: ['🔥', '❤️', '😂', '👏', '🤯'].map((emoji) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: TVFocusable(
                      onPressed: () => watchPartyVm.sendReaction(emoji),
                      borderRadius: BorderRadius.circular(16),
                      scaleFactor: 1.25,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: Text(emoji,
                            style: TextStyle(fontSize: isTV ? 20 : 16)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}
