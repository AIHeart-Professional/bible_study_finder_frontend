import 'package:flutter/material.dart';
import '../../utils/auth_storage.dart';
import '../../utils/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _logger = getLogger('HomePage');
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late AnimationController _fadeController1;
  late AnimationController _fadeController2;
  late AnimationController _fadeController3;
  late Animation<double> _fadeAnimation1;
  late Animation<double> _fadeAnimation2;
  late Animation<double> _fadeAnimation3;

  String? _username;
  int _currentMessageIndex = 0;
  List<String> _welcomeMessages = [];

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _initializeAnimations();
  }

  Future<void> _loadUsername() async {
    _logger.debug('Loading username');
    try {
      final user = await AuthStorage.getUser();
      if (mounted) {
        setState(() {
          _username = user?.username ?? user?.firstName ?? 'Guest';
        });
        _initializeWelcomeMessages();
      }
    } catch (e, stackTrace) {
      _logger.error('Error loading username', error: e, stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          _username = 'Guest';
        });
        _initializeWelcomeMessages();
      }
    }
  }

  void _initializeWelcomeMessages() {
    if (_username != null) {
      _welcomeMessages = [
        'Welcome to the Bible Study Finder $_username',
        'You can use the chatbox to navigate this app or manually navigate it.',
        'You can also ask us any question and we will do our best to assist you',
      ];
      _startWelcomeAnimation();
    }
  }

  void _initializeAnimations() {
    _fadeController1 = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeController2 = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeController3 = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController1,
        curve: Curves.easeInOut,
      ),
    );
    _fadeAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController2,
        curve: Curves.easeInOut,
      ),
    );
    _fadeAnimation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController3,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startWelcomeAnimation() {
    if (_welcomeMessages.isEmpty) return;

    _fadeController1.forward().then((_) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _fadeController1.reverse().then((_) {
            if (mounted && _welcomeMessages.length > 1) {
              setState(() => _currentMessageIndex = 1);
              _fadeController2.forward().then((_) {
                Future.delayed(const Duration(seconds: 3), () {
                  if (mounted) {
                    _fadeController2.reverse().then((_) {
                      if (mounted && _welcomeMessages.length > 2) {
                        setState(() => _currentMessageIndex = 2);
                        _fadeController3.forward().then((_) {
                          Future.delayed(const Duration(seconds: 3), () {
                            if (mounted) {
                              _fadeController3.reverse();
                            }
                          });
                        });
                      }
                    });
                  }
                });
              });
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _fadeController1.dispose();
    _fadeController2.dispose();
    _fadeController3.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _logger.debug('Sending message: $message');
    _messageController.clear();
    // TODO: Implement API call to send message
  }

  Animation<double> _getCurrentAnimation() {
    switch (_currentMessageIndex) {
      case 0:
        return _fadeAnimation1;
      case 1:
        return _fadeAnimation2;
      case 2:
        return _fadeAnimation3;
      default:
        return _fadeAnimation1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWelcomeSection(context),
        Expanded(
          child: _buildChatArea(context),
        ),
        _buildChatInput(context),
      ],
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    if (_welcomeMessages.isEmpty || _currentMessageIndex >= _welcomeMessages.length) {
      return const SizedBox(height: 0);
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: AnimatedBuilder(
        animation: _getCurrentAnimation(),
        builder: (context, child) {
          return Opacity(
            opacity: _getCurrentAnimation().value,
            child: Text(
              _welcomeMessages[_currentMessageIndex],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatArea(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Start a conversation',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ask me anything or use the chatbox to navigate the app',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send, color: Colors.white),
                tooltip: 'Send message',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
