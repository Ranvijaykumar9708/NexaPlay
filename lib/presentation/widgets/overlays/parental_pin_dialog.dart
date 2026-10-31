import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../inputs/tv_num_keypad.dart';
import '../../../widgets/tv_focusable.dart';

class ParentalPinDialog extends StatefulWidget {
  final Function(bool isSuccess) onVerified;
  final bool isTV;

  const ParentalPinDialog({
    super.key,
    required this.onVerified,
    this.isTV = true,
  });

  @override
  State<ParentalPinDialog> createState() => _ParentalPinDialogState();
}

class _ParentalPinDialogState extends State<ParentalPinDialog> {
  String _pin = '';
  bool _hasError = false;

  void _onDigit(String d) {
    if (_pin.length < 4) {
      setState(() {
        _hasError = false;
        _pin += d;
      });

      if (_pin.length == 4) {
        if (_pin == '1234') {
          widget.onVerified(true);
          Navigator.pop(context);
        } else {
          setState(() {
            _hasError = true;
            _pin = '';
          });
        }
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _hasError = false;
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _onClear() {
    setState(() {
      _hasError = false;
      _pin = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: widget.isTV ? 400 : 320),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surface.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryViolet, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryPurple.withValues(alpha: 0.35),
              blurRadius: 24,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, color: AppTheme.primaryViolet, size: 36),
            const SizedBox(height: 12),
            Text(
              'Parental Control Gate',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Enter 4-digit PIN to exit Kids Profile (Default: 1234)',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 18),

            // PIN Dots Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final filled = index < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? AppTheme.accentCyan : Colors.white24,
                    boxShadow: filled
                        ? [
                            BoxShadow(
                              color: AppTheme.accentCyan.withValues(alpha: 0.5),
                              blurRadius: 6,
                            )
                          ]
                        : [],
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),

            if (_hasError)
              Text(
                'Incorrect PIN. Please try again.',
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.redAccent),
              ),
            const SizedBox(height: 16),

            // Keypad
            TvNumKeypad(
              isTV: widget.isTV,
              onDigit: _onDigit,
              onBackspace: _onBackspace,
              onClear: _onClear,
            ),
            const SizedBox(height: 16),

            TVFocusable(
              onPressed: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
