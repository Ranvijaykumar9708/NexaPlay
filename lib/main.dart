import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'models/content_item.dart';
import 'widgets/app_header.dart';
import 'widgets/mobile_bottom_bar.dart';
import 'widgets/vip_pass_sheet.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/browse_screen.dart';
import 'screens/content_details_screen.dart';
import 'screens/video_player_screen.dart';
import 'screens/search_screen.dart';
import 'screens/watchlist_screen.dart';
import 'screens/settings_screen.dart';
import 'views/live_tv_view.dart';
import 'views/downloads_view.dart';
import 'presentation/widgets/overlays/ai_voice_modal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: NexaPlayApp(),
    ),
  );
}

class NexaPlayApp extends ConsumerWidget {
  const NexaPlayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'NexaPlay - Smart TV & Mobile Cinema',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const NexaPlayRoot(),
    );
  }
}

enum AppFlowState {
  splash,
  onboarding,
  auth,
  profile,
  main,
}

enum OverlayScreen {
  none,
  details,
  player,
  search,
  settings,
  vip,
}

class NexaPlayRoot extends ConsumerStatefulWidget {
  const NexaPlayRoot({super.key});

  @override
  ConsumerState<NexaPlayRoot> createState() => _NexaPlayRootState();
}

class _NexaPlayRootState extends ConsumerState<NexaPlayRoot> {
  AppFlowState _flowState = AppFlowState.splash;
  AppTab _currentTab = AppTab.home;
  OverlayScreen _overlay = OverlayScreen.none;
  ContentItem? _selectedItem;

  void _openDetails(ContentItem item) {
    setState(() {
      _selectedItem = item;
      _overlay = OverlayScreen.details;
    });
  }

  void _openPlayer(ContentItem item) {
    setState(() {
      _selectedItem = item;
      _overlay = OverlayScreen.player;
    });
  }

  void _closeOverlay() {
    setState(() {
      _overlay = OverlayScreen.none;
    });
  }

  void _openVipModal() {
    showDialog(
      context: context,
      builder: (ctx) => VipPassSheet(
        isTV: MediaQuery.of(context).size.width > 700,
        onClose: () => Navigator.pop(ctx),
      ),
    );
  }

  void _openAiVoiceModal() {
    showDialog(
      context: context,
      builder: (ctx) => AiVoiceModal(
        isTV: MediaQuery.of(context).size.width > 700,
        onSelectContent: (item) {
          Navigator.pop(ctx);
          _openDetails(item);
        },
      ),
    );
  }

  bool _handleBackPress() {
    if (_overlay != OverlayScreen.none) {
      if (_overlay == OverlayScreen.player && _selectedItem != null) {
        setState(() => _overlay = OverlayScreen.details);
      } else {
        _closeOverlay();
      }
      return true;
    }

    if (_currentTab != AppTab.home) {
      setState(() => _currentTab = AppTab.home);
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTV = size.width > 700;

    return PopScope(
      canPop: _overlay == OverlayScreen.none && _currentTab == AppTab.home,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackPress();
        }
      },
      child: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.escape ||
                event.logicalKey == LogicalKeyboardKey.backspace) {
              final handled = _handleBackPress();
              if (handled) return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Scaffold(
          backgroundColor: AppTheme.background,
          body: _buildCurrentFlow(isTV),
          bottomNavigationBar: (!isTV &&
                  _flowState == AppFlowState.main &&
                  _overlay == OverlayScreen.none)
              ? MobileBottomBar(
                  currentTab: _currentTab,
                  onTabSelected: (tab) => setState(() => _currentTab = tab),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildCurrentFlow(bool isTV) {
    switch (_flowState) {
      case AppFlowState.splash:
        return SplashScreen(
          onFinished: () {
            setState(() {
              _flowState = AppFlowState.onboarding;
            });
          },
        );

      case AppFlowState.onboarding:
        return OnboardingScreen(
          onFinish: () {
            setState(() {
              _flowState = AppFlowState.auth;
            });
          },
        );

      case AppFlowState.auth:
        return AuthScreen(
          onAuthenticated: () {
            setState(() {
              _flowState = AppFlowState.profile;
            });
          },
          onGuestDemo: () {
            setState(() {
              _flowState = AppFlowState.profile;
            });
          },
        );

      case AppFlowState.profile:
        return ProfileScreen(
          onProfileChosen: () {
            setState(() {
              _flowState = AppFlowState.main;
              _currentTab = AppTab.home;
            });
          },
        );

      case AppFlowState.main:
        return _buildMainExperience(isTV);
    }
  }

  Widget _buildMainExperience(bool isTV) {
    // 1. Overlay Player
    if (_overlay == OverlayScreen.player && _selectedItem != null) {
      return VideoPlayerScreen(
        item: _selectedItem!,
        isTV: isTV,
        onExit: () {
          setState(() => _overlay = OverlayScreen.details);
        },
      );
    }

    // 2. Overlay Details
    if (_overlay == OverlayScreen.details && _selectedItem != null) {
      return ContentDetailsScreen(
        item: _selectedItem!,
        isTV: isTV,
        onBack: _closeOverlay,
        onPlay: () => _openPlayer(_selectedItem!),
        onSelectSimilar: (sim) => _openDetails(sim),
      );
    }

    // 3. Overlay Settings
    if (_overlay == OverlayScreen.settings) {
      return SettingsScreen(
        isTV: isTV,
        onBack: _closeOverlay,
        onLogout: () {
          setState(() {
            _overlay = OverlayScreen.none;
            _flowState = AppFlowState.auth;
          });
        },
      );
    }

    // 4. Overlay Search
    if (_overlay == OverlayScreen.search) {
      return Column(
        children: [
          AppHeader(
            currentTab: _currentTab,
            isTV: isTV,
            onTabSelected: (tab) {
              setState(() {
                _currentTab = tab;
                _overlay = OverlayScreen.none;
              });
            },
            onSearchPressed: () {},
            onProfilePressed: () =>
                setState(() => _flowState = AppFlowState.profile),
            onSettingsPressed: () =>
                setState(() => _overlay = OverlayScreen.settings),
            onVipPressed: _openVipModal,
            onAiVoicePressed: _openAiVoiceModal,
          ),
          Expanded(
            child: SearchScreen(
              isTV: isTV,
              onItemSelect: (item) => _openDetails(item),
            ),
          ),
        ],
      );
    }

    // Default Main Navigation with Persistent AppHeader
    return Column(
      children: [
        AppHeader(
          currentTab: _currentTab,
          isTV: isTV,
          onTabSelected: (tab) => setState(() => _currentTab = tab),
          onSearchPressed: () =>
              setState(() => _overlay = OverlayScreen.search),
          onProfilePressed: () =>
              setState(() => _flowState = AppFlowState.profile),
          onSettingsPressed: () =>
              setState(() => _overlay = OverlayScreen.settings),
          onVipPressed: _openVipModal,
          onAiVoicePressed: _openAiVoiceModal,
        ),
        Expanded(
          child: _buildTabBody(isTV),
        ),
      ],
    );
  }

  Widget _buildTabBody(bool isTV) {
    switch (_currentTab) {
      case AppTab.home:
        return HomeScreen(
          isTV: isTV,
          onItemSelect: (item) => _openDetails(item),
          onPlay: (item) => _openPlayer(item),
        );

      case AppTab.movies:
        return BrowseScreen(
          filterMoviesOnly: true,
          isTV: isTV,
          onItemSelect: (item) => _openDetails(item),
        );

      case AppTab.series:
        return BrowseScreen(
          filterSeriesOnly: true,
          isTV: isTV,
          onItemSelect: (item) => _openDetails(item),
        );

      case AppTab.liveTv:
        return LiveTvView(
          isTV: isTV,
          onPlayChannel: (channelItem) => _openPlayer(channelItem),
        );

      case AppTab.kids:
        return BrowseScreen(
          filterKidsOnly: true,
          isTV: isTV,
          onItemSelect: (item) => _openDetails(item),
        );

      case AppTab.myList:
        return WatchlistScreen(
          isTV: isTV,
          onItemSelect: (item) => _openDetails(item),
          onBrowseCatalogue: () =>
              setState(() => _currentTab = AppTab.movies),
        );

      case AppTab.downloads:
        return DownloadsView(
          isTV: isTV,
          onPlayItem: (item) => _openPlayer(item),
        );
    }
  }
}
