import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../services/yarn_adapter.dart';

class YarnChatScreen extends StatefulWidget {
  final String? initialQuery;

  const YarnChatScreen({
    super.key,
    this.initialQuery,
  });

  @override
  State<YarnChatScreen> createState() => _YarnChatScreenState();
}

class _YarnChatScreenState extends State<YarnChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final YarnAdapter _yarnAdapter = YarnAdapter();
  
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  
  String _selectedLanguage = 'Nigerian English';
  bool _isLoading = false;
  bool _isRecording = false;
  
  final List<Map<String, dynamic>> _messages = [];
  
  final Map<String, String> _languages = {
    'Nigerian English': 'en-ng',
    'Igbo': 'ig',
    'Yoruba': 'yo',
    'Hausa': 'ha',
  };

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: TrustBaseTheme.standardAnimation,
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: TrustBaseTheme.decelerateCurve,
    ));
    
    _slideController.forward();
    
    // Add welcome message
    _addMessage(
      'Hello! I\'m YarnGPT, your AI assistant for understanding data privacy and consent. How can I help you today?',
      isUser: false,
    );
    
    // Handle initial query if provided
    if (widget.initialQuery != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _messageController.text = widget.initialQuery!;
        _sendMessage();
      });
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _addMessage(String content, {bool isUser = true, String? audioUrl}) {
    setState(() {
      _messages.add({
        'content': content,
        'isUser': isUser,
        'timestamp': DateTime.now(),
        'audioUrl': audioUrl,
      });
    });
    
    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: TrustBaseTheme.standardAnimation,
          curve: TrustBaseTheme.decelerateCurve,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading) return;
    
    _messageController.clear();
    _addMessage(message, isUser: true);
    
    setState(() => _isLoading = true);
    
    try {
      final response = await _yarnAdapter.generateResponse(
        text: message,
        language: _languages[_selectedLanguage] ?? 'en-ng',
      );
      
      _addMessage(
        response['text'],
        isUser: false,
        audioUrl: response['audioUrl'],
      );
    } catch (e) {
      _addMessage(
        'Sorry, I encountered an error. Please try again.',
        isUser: false,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _playAudio(String audioUrl) async {
    try {
      await _audioPlayer.play(AssetSource(audioUrl));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not play audio')),
      );
    }
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TrustBaseColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Select Language',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            
            const SizedBox(height: 16),
            
            ..._languages.keys.map((language) {
              return ListTile(
                title: Text(language),
                trailing: _selectedLanguage == language
                    ? const Icon(Icons.check, color: TrustBaseColors.accentTeal)
                    : null,
                onTap: () {
                  setState(() => _selectedLanguage = language);
                  Navigator.pop(context);
                },
              );
            }).toList(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TrustBaseColors.background,
      appBar: AppBar(
        title: const Text('YarnGPT Assistant'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          // Language Selector
          TextButton.icon(
            onPressed: _showLanguageSelector,
            icon: const Icon(Icons.language, size: 18),
            label: Text(
              _selectedLanguage.split(' ')[0], // Show first word
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
            
            // Loading Indicator
            if (_isLoading)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          TrustBaseColors.accentTeal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'YarnGPT is thinking...',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            
            // Input Area
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: TrustBaseColors.border),
                ),
              ),
              child: Row(
                children: [
                  // Text Input
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask about your data privacy...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: TrustBaseColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: TrustBaseColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: TrustBaseColors.accentTeal),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Microphone Button (Design Only)
                  Container(
                    decoration: BoxDecoration(
                      color: _isRecording 
                        ? TrustBaseColors.error 
                        : TrustBaseColors.border,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() => _isRecording = !_isRecording);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Voice input - design only'),
                          ),
                        );
                      },
                      icon: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: _isRecording ? Colors.white : TrustBaseColors.textSecondary,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Send Button
                  Container(
                    decoration: const BoxDecoration(
                      color: TrustBaseColors.accentTeal,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    final audioUrl = message['audioUrl'] as String?;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser 
          ? MainAxisAlignment.end 
          : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            // YarnGPT Avatar
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: TrustBaseColors.accentTeal,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          // Message Bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser 
                  ? TrustBaseColors.primaryBlue 
                  : Colors.white,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
                border: isUser 
                  ? null 
                  : Border.all(color: TrustBaseColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['content'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isUser ? Colors.white : TrustBaseColors.textPrimary,
                    ),
                  ),
                  
                  if (audioUrl != null) ...[
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _playAudio(audioUrl),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: TrustBaseColors.accentTeal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              size: 16,
                              color: TrustBaseColors.accentTeal,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Play Audio',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: TrustBaseColors.accentTeal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            // User Avatar
            CircleAvatar(
              radius: 16,
              backgroundColor: TrustBaseColors.primaryBlue.withOpacity(0.1),
              child: const Icon(
                Icons.person,
                color: TrustBaseColors.primaryBlue,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
}