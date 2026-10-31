import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/tv_focusable.dart';

class TvNumKeypad extends StatelessWidget {
  final Function(String) onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final bool isTV;

  const TvNumKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
    this.isTV = true,
  });

  static const List<List<String>> _keypadLayout = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['CLEAR', '0', '⌫'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _keypadLayout.map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TVFocusable(
                  onPressed: () {
                    if (key == 'CLEAR') {
                      onClear();
                    } else if (key == '⌫') {
                      onBackspace();
                    } else {
                      onDigit(key);
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  scaleFactor: 1.12,
                  child: Container(
                    width: isTV ? 74 : 64,
                    height: isTV ? 46 : 40,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        key,
                        style: GoogleFonts.outfit(
                          fontSize: key == 'CLEAR' ? 12 : 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
