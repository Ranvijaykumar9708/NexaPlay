import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/watch_party_viewmodel.dart';
import '../../../widgets/tv_focusable.dart';

class WatchPartyDialog extends ConsumerStatefulWidget {
  final String contentId;
  final String contentTitle;
  final bool isTV;

  const WatchPartyDialog({
    super.key,
    required this.contentId,
    required this.contentTitle,
    this.isTV = true,
  });

  @override
  ConsumerState<WatchPartyDialog> createState() => _WatchPartyDialogState();
}

class _WatchPartyDialogState extends ConsumerState<WatchPartyDialog> {
  final TextEditingController _codeController = TextEditingController();
  bool _isJoining = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watchPartyVm = ref.watch(watchPartyProvider);
    final isTV = widget.isTV;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: isTV ? 480 : 340),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surface.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppTheme.accentCyan.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentCyan.withValues(alpha: 0.25),
              blurRadius: 24,
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
                          color: AppTheme.accentCyan.withValues(alpha: 0.2),
                        ),
                        child: const Icon(Icons.group_work_rounded,
                            color: AppTheme.accentCyan, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NexaPlay Watch Party',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.contentTitle,
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

              if (watchPartyVm.isInParty) ...[
                // Room Active View
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.accentCyan, width: 1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'ROOM CODE',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textMuted,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        watchPartyVm.currentRoom!.roomCode,
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: AppTheme.accentCyan,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Share this code with friends on TV or Mobile to sync playback',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                            fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Members
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people, color: AppTheme.primaryViolet, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '${watchPartyVm.currentRoom!.participantsCount} Friends Connected (Synced)',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                TVFocusable(
                  onPressed: () {
                    watchPartyVm.leaveParty();
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                    ),
                    child: const Text('Leave Watch Party',
                        style: TextStyle(
                            color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ),
                ),
              ] else if (!_isJoining) ...[
                // Options: Create or Join
                Text(
                  'Watch movies synchronized with friends with real-time emoji reactions',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                      fontSize: 13, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 24),

                TVFocusable(
                  autoFocus: true,
                  onPressed: () {
                    watchPartyVm.createRoom(widget.contentId, 'Ranvijay');
                  },
                  borderRadius: BorderRadius.circular(10),
                  scaleFactor: 1.05,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: AppTheme.brandGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Host New Watch Party',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                TVFocusable(
                  onPressed: () => setState(() => _isJoining = true),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Center(
                      child: Text(
                        'Join with Room Code',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Join Form
                TextField(
                  controller: _codeController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.characters,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. NX-7821',
                    hintStyle: const TextStyle(color: AppTheme.textMuted),
                    filled: true,
                    fillColor: AppTheme.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => setState(() => _isJoining = false),
                        child: const Text('Back', style: TextStyle(color: Colors.white60)),
                      ),
                    ),
                    Expanded(
                      child: TVFocusable(
                        onPressed: () {
                          if (_codeController.text.trim().isNotEmpty) {
                            watchPartyVm.joinRoom(_codeController.text.trim(), 'Guest');
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: AppTheme.brandGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text('Join Room',
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
