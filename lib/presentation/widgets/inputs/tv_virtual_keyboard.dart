import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/tv_focusable.dart';

class TvVirtualKeyboard extends StatelessWidget {
  final Function(String) onKeyPress;

  const TvVirtualKeyboard({
    super.key,
    required this.onKeyPress,
  });

  static const List<List<String>> _keyboardLayout = [
    ['A', 'B', 'C', 'D', 'E', 'F'],
    ['G', 'H', 'I', 'J', 'K', 'L'],
    ['M', 'N', 'O', 'P', 'Q', 'R'],
    ['S', 'T', 'U', 'V', 'W', 'X'],
    ['Y', 'Z', '1', '2', '3', '4'],
    ['5', '6', '7', '8', '9', '0'],
    ['SPACE', '⌫', 'CLEAR'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _keyboardLayout.map((row) {
        return Row(
          children: row.map((key) {
            final isAction = key == 'SPACE' || key == '⌫' || key == 'CLEAR';
            return Expanded(
              flex: key == 'SPACE' ? 3 : (isAction ? 2 : 1),
              child: Padding(
                padding: const EdgeInsets.all(2.5),
                child: TVFocusable(
                  onPressed: () => onKeyPress(key),
                  borderRadius: BorderRadius.circular(8),
                  scaleFactor: 1.15,
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: isAction
                          ? AppTheme.primaryPurple.withValues(alpha: 0.3)
                          : AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        key,
                        style: GoogleFonts.outfit(
                          fontSize: isAction ? 11 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
