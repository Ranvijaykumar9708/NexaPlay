import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_theme.dart';
import '../models/content_item.dart';
import '../viewmodels/app_providers.dart';
import '../widgets/tv_focusable.dart';
import '../widgets/x_ray_modal.dart';
import '../viewmodels/audio_master_viewmodel.dart';
import '../viewmodels/watch_party_viewmodel.dart';
import '../presentation/widgets/player/floating_reactions_overlay.dart';
import '../presentation/widgets/player/sports_multicam_bar.dart';
import '../presentation/widgets/overlays/watch_party_dialog.dart';
import '../presentation/widgets/overlays/audio_master_dialog.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final ContentItem item;
  final VoidCallback onExit;
  final bool isTV;

  const VideoPlayerScreen({
    super.key,
    required this.item,
    required this.onExit,
    this.isTV = true,
  });

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _showControls = true;
  Timer? _hideTimer;
  Timer? _progressSaveTimer;

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = const Duration(hours: 2, minutes: 28);
  bool _isPlaying = true;
  Timer? _simulatedTimer;
  bool _isDolbyAtmosOn = true;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    final playbackMap = ref.read(playbackProvider).progress;
    final savedProgress = playbackMap[widget.item.id];

    try {
      final uri = Uri.parse(widget.item.streamUrl);
      final controller = VideoPlayerController.networkUrl(uri);
      await controller.initialize();
      _controller = controller;

      // Resume from saved position
      if (savedProgress != null && savedProgress.positionSeconds > 5) {
        final resumeDuration =
            Duration(seconds: savedProgress.positionSeconds);
        if (resumeDuration < controller.value.duration) {
          await controller.seekTo(resumeDuration);
        }
      }

      await controller.play();
      controller.addListener(_videoListener);

      if (mounted) {
        setState(() {
          _isPlaying = true;
          _totalDuration = controller.value.duration;
        });
      }
    } catch (e) {
      debugPrint('Video Player fallback: $e');
      if (savedProgress != null && savedProgress.positionSeconds > 0) {
        _currentPosition = Duration(seconds: savedProgress.positionSeconds);
      }
      _startSimulatedPlayback();
      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
    }

    _progressSaveTimer =
        Timer.periodic(const Duration(seconds: 4), (_) => _saveCurrentProgress());
  }

  void _videoListener() {
    if (!mounted || _controller == null) return;
    setState(() {
      _currentPosition = _controller!.value.position;
      _totalDuration = _controller!.value.duration;
      _isPlaying = _controller!.value.isPlaying;
    });
  }

  void _startSimulatedPlayback() {
    _simulatedTimer?.cancel();
    _simulatedTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_isPlaying) {
        setState(() {
          _currentPosition += const Duration(seconds: 1);
          if (_currentPosition >= _totalDuration) {
            _currentPosition = _totalDuration;
            _isPlaying = false;
          }
        });
      }
    });
  }

  void _saveCurrentProgress() {
    if (_totalDuration.inSeconds > 0) {
      ref.read(playbackProvider).updateProgress(
            widget.item.id,
            _currentPosition.inSeconds,
            _totalDuration.inSeconds,
          );
    }
  }

  void _togglePlayPause() {
    _showAndResetControls();
    if (_controller != null && _controller!.value.isInitialized) {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    } else {
      setState(() => _isPlaying = !_isPlaying);
    }
  }

  void _seekRelative(int seconds) {
    _showAndResetControls();
    final newPos = _currentPosition + Duration(seconds: seconds);
    final clamped = Duration(
      seconds: newPos.inSeconds.clamp(0, _totalDuration.inSeconds),
    );

    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.seekTo(clamped);
    } else {
      setState(() => _currentPosition = clamped);
    }
    _saveCurrentProgress();
  }

  void _skipIntro() {
    final skipTo = Duration(seconds: widget.item.introSkipEnd);
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.seekTo(skipTo);
    } else {
      setState(() => _currentPosition = skipTo);
    }
    _showAndResetControls();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _isPlaying && _showControls) {
        setState(() => _showControls = false);
      }
    });
  }

  void _showAndResetControls() {
    if (!_showControls) {
      setState(() => _showControls = true);
    }
    _startHideTimer();
  }

  void _openXRay() {
    showDialog(
      context: context,
      builder: (ctx) => XRayModal(
        item: widget.item,
        isTV: widget.isTV,
        onClose: () => Navigator.pop(ctx),
      ),
    );
  }

  @override
  void dispose() {
    _saveCurrentProgress();
    _hideTimer?.cancel();
    _progressSaveTimer?.cancel();
    _simulatedTimer?.cancel();
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isTV = widget.isTV;
    final progressRatio = _totalDuration.inMilliseconds > 0
        ? (_currentPosition.inMilliseconds / _totalDuration.inMilliseconds)
            .clamp(0.0, 1.0)
        : 0.0;

    final isWithinIntro = _currentPosition.inSeconds >= widget.item.introSkipStart &&
        _currentPosition.inSeconds <= widget.item.introSkipEnd;

    final isNearEnd = _totalDuration.inSeconds > 60 &&
        _currentPosition.inSeconds >= _totalDuration.inSeconds - 25;

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          _showAndResetControls();
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _seekRelative(-10);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _seekRelative(10);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.space ||
              event.logicalKey == LogicalKeyboardKey.select ||
              event.logicalKey == LogicalKeyboardKey.gameButtonA) {
            _togglePlayPause();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.escape ||
              event.logicalKey == LogicalKeyboardKey.backspace) {
            widget.onExit();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _showAndResetControls,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Video Player View with IMAX Enhanced Ratio Support
              if (_controller != null && _controller!.value.isInitialized)
                Center(
                  child: AspectRatio(
                    aspectRatio: ref.watch(audioMasterProvider).isImaxEnhanced
                        ? 1.78
                        : _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                )
              else
                Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.item.backdropUrl,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.black.withValues(alpha: 0.45),
                    ),
                  ],
                ),

              // Floating Live Emoji Reactions (Watch Party)
              FloatingReactionsOverlay(isTV: isTV),

              // Live Sports Multi-Cam Switcher
              if (widget.item.genres.contains('Sports') ||
                  widget.item.duration == 'LIVE')
                Positioned(
                  top: 75,
                  right: isTV ? 48 : 16,
                  child: SportsMulticamBar(isTV: isTV),
                ),

              // 2. Skip Intro Button (Indian Opening Theme Skip)
              if (isWithinIntro)
                Positioned(
                  bottom: _showControls ? (isTV ? 120 : 90) : 40,
                  right: isTV ? 48 : 20,
                  child: TVFocusable(
                    autoFocus: true,
                    onPressed: _skipIntro,
                    borderRadius: BorderRadius.circular(8),
                    scaleFactor: 1.1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppTheme.accentCyan, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentCyan.withValues(alpha: 0.35),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.fast_forward_rounded,
                              color: AppTheme.accentCyan, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Skip Intro',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // 3. Next Episode Auto-Countdown Overlay
              if (isNearEnd && !widget.item.isMovie)
                Positioned(
                  bottom: 80,
                  right: isTV ? 48 : 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.primaryViolet, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.skip_next,
                            color: AppTheme.primaryViolet, size: 28),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Next Episode in 5s',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Episode 2 • Coming up',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              // 4. Player HUD Overlay
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: IgnorePointer(
                  ignoring: !_showControls,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.88),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.94),
                            ],
                            stops: const [0.0, 0.25, 0.7, 1.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      // Top Bar
                      Positioned(
                        top: 24,
                        left: isTV ? 48 : 20,
                        right: isTV ? 48 : 20,
                        child: Row(
                          children: [
                            TVFocusable(
                              onPressed: widget.onExit,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black45,
                                ),
                                child: const Icon(Icons.arrow_back,
                                    color: Colors.white, size: 24),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.item.title,
                                  style: GoogleFonts.outfit(
                                    fontSize: isTV ? 20 : 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                if (widget.item.hindiTitle.isNotEmpty)
                                  Text(
                                    widget.item.hindiTitle,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                            const Spacer(),

                            // Watch Party Button
                            TVFocusable(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => WatchPartyDialog(
                                    contentId: widget.item.id,
                                    contentTitle: widget.item.title,
                                    isTV: isTV,
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: ref.watch(watchPartyProvider).isInParty
                                      ? AppTheme.accentCyan.withValues(alpha: 0.25)
                                      : Colors.white12,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: ref.watch(watchPartyProvider).isInParty
                                        ? AppTheme.accentCyan
                                        : Colors.white24,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.group_work_rounded,
                                        color: AppTheme.accentCyan, size: 16),
                                    const SizedBox(width: 5),
                                    Text(
                                      ref.watch(watchPartyProvider).isInParty
                                          ? 'PARTY ON'
                                          : 'PARTY',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Studio Master Controls Button
                            TVFocusable(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AudioMasterDialog(isTV: isTV),
                                );
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.tune_rounded,
                                        color: Colors.white, size: 16),
                                    SizedBox(width: 5),
                                    Text(
                                      'MASTER',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // X-Ray Mode Button
                            TVFocusable(
                              onPressed: _openXRay,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: AppTheme.accentCyan.withValues(alpha: 0.5)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.info_outline,
                                        color: AppTheme.accentCyan, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'X-Ray',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.accentCyan,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Dolby Atmos Toggle
                            TVFocusable(
                              onPressed: () {
                                setState(() =>
                                    _isDolbyAtmosOn = !_isDolbyAtmosOn);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _isDolbyAtmosOn
                                      ? AppTheme.primaryPurple
                                          .withValues(alpha: 0.3)
                                      : Colors.white12,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _isDolbyAtmosOn
                                        ? AppTheme.primaryViolet
                                        : Colors.white24,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.surround_sound,
                                        color: _isDolbyAtmosOn
                                            ? AppTheme.accentCyan
                                            : Colors.white54,
                                        size: 18),
                                    const SizedBox(width: 5),
                                    Text(
                                      'ATMOS',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: _isDolbyAtmosOn
                                            ? Colors.white
                                            : Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Center Play / Pause
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TVFocusable(
                              onPressed: () => _seekRelative(-10),
                              borderRadius: BorderRadius.circular(30),
                              scaleFactor: 1.15,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black45,
                                ),
                                child: const Icon(Icons.replay_10_rounded,
                                    color: Colors.white, size: 36),
                              ),
                            ),
                            SizedBox(width: isTV ? 48 : 24),

                            TVFocusable(
                              autoFocus: true,
                              onPressed: _togglePlayPause,
                              borderRadius: BorderRadius.circular(45),
                              scaleFactor: 1.15,
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppTheme.brandGradient,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryPurple
                                          .withValues(alpha: 0.6),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: isTV ? 48 : 36,
                                ),
                              ),
                            ),
                            SizedBox(width: isTV ? 48 : 24),

                            TVFocusable(
                              onPressed: () => _seekRelative(10),
                              borderRadius: BorderRadius.circular(30),
                              scaleFactor: 1.15,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black45,
                                ),
                                child: const Icon(Icons.forward_10_rounded,
                                    color: Colors.white, size: 36),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom Progress & Badges
                      Positioned(
                        bottom: isTV ? 32 : 18,
                        left: isTV ? 48 : 20,
                        right: isTV ? 48 : 20,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TVFocusable(
                              onPressed: () => _seekRelative(30),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                height: 8,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white24,
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: progressRatio,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppTheme.primaryPurple,
                                          AppTheme.accentCyan
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                  ),
                                ),
                                Row(
                                  children: [
                                    _buildBadge('DOLBY VISION'),
                                    const SizedBox(width: 8),
                                    _buildBadge('ATMOS 7.1'),
                                    const SizedBox(width: 8),
                                    _buildBadge('4K ULTRA HD'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white24, width: 0.8),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: AppTheme.accentCyan,
        ),
      ),
    );
  }
}
