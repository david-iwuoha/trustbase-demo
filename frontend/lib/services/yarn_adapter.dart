import 'dart:math';

class YarnAdapter {
  // Demo mode deterministic responses
  static const Map<String, Map<String, dynamic>> _demoResponses = {
    // Nigerian English responses
    'en-ng': {
      'default': {
        'text': 'I understand you want to know more about your data privacy. In Nigeria, organizations must get your clear consent before using your personal data. You have the right to know what data they collect, why they need it, and how long they keep it.',
        'audioUrl': 'demo_audio/en_ng_default.mp3',
      },
      'explain_access': {
        'text': 'When an organization accesses your data, they should have a valid reason that you previously agreed to. For example, banks access your transaction history to verify your identity for loans, which helps prevent fraud and ensures you qualify for the right financial products.',
        'audioUrl': 'demo_audio/en_ng_explain.mp3',
      },
      'consent_rights': {
        'text': 'Your consent rights in Nigeria include: the right to be informed about data collection, the right to access your data, the right to correct wrong information, the right to delete your data, and the right to withdraw consent at any time.',
        'audioUrl': 'demo_audio/en_ng_rights.mp3',
      },
    },
    
    // Igbo responses
    'ig': {
      'default': {
        'text': 'Aghọtara m na ịchọrọ ịmata ihe gbasara nchekwa data gị. Na Naịjirịa, ụlọ ọrụ ga-enweta nkwenye gị doro anya tupu ha eji data nkeonwe gị mee ihe.',
        'audioUrl': 'demo_audio/ig_default.mp3',
      },
      'explain_access': {
        'text': 'Mgbe ụlọ ọrụ na-enweta data gị, ha kwesịrị inwe ezigbo ihe kpatara ya nke ị kwenyere na mbụ. Dịka ọmụmaatụ, ụlọ akụ na-elele akụkọ ego gị iji chọpụta onye ị bụ maka mbinye ego.',
        'audioUrl': 'demo_audio/ig_explain.mp3',
      },
    },
    
    // Yoruba responses
    'yo': {
      'default': {
        'text': 'Mo ye mi pe o fe mo nipa aabo data re. Ni Nigeria, awon ile-ise gbodo gba igbanilaaye to han kedere lati odo re ki won to lo data ti ara re.',
        'audioUrl': 'demo_audio/yo_default.mp3',
      },
      'explain_access': {
        'text': 'Nigbati ile-ise kan ba n wole si data re, won gbodo ni idi to dara ti o ti gba lati tele. Fun apere, awon ile-owo n wo itan owo re lati ri daju pe eni ti o je fun awin owo.',
        'audioUrl': 'demo_audio/yo_explain.mp3',
      },
    },
    
    // Hausa responses
    'ha': {
      'default': {
        'text': 'Na fahimci kana son ka san game da kare bayananku. A Najeriya, kamfanoni dole su sami izininku da bayyane kafin su yi amfani da bayananku na sirri.',
        'audioUrl': 'demo_audio/ha_default.mp3',
      },
      'explain_access': {
        'text': 'Lokacin da kamfani ya shiga bayananku, ya kamata su sami dalili mai kyau da kuka yarda da shi a baya. Misali, bankuna suna kallon tarihin kuɗin ku don tabbatar da ko kun cancanci rancen da kuke nema.',
        'audioUrl': 'demo_audio/ha_explain.mp3',
      },
    },
  };

  /// Generate response in demo mode with deterministic outputs
  Future<Map<String, dynamic>> generateResponse({
    required String text,
    required String language,
  }) async {
    // Simulate API delay
    await Future.delayed(Duration(milliseconds: 800 + Random().nextInt(1200)));
    
    final responses = _demoResponses[language] ?? _demoResponses['en-ng']!;
    
    // Determine response type based on input text
    String responseKey = 'default';
    
    if (_containsKeywords(text, ['explain', 'why', 'access', 'purpose'])) {
      responseKey = 'explain_access';
    } else if (_containsKeywords(text, ['rights', 'consent', 'withdraw', 'delete'])) {
      responseKey = 'consent_rights';
    }
    
    final response = responses[responseKey] ?? responses['default']!;
    
    return {
      'text': response['text'],
      'audioUrl': response['audioUrl'],
    };
  }

  bool _containsKeywords(String text, List<String> keywords) {
    final lowerText = text.toLowerCase();
    return keywords.any((keyword) => lowerText.contains(keyword));
  }

  /* 
   * REAL YARNGPT ADAPTER PLACEHOLDER
   * 
   * To replace this demo adapter with the real YarnGPT model:
   * 
   * 1. Set up YarnGPT server:
   *    - Clone the YarnGPT repository
   *    - Install Python dependencies (torch, transformers, etc.)
   *    - Download WavTokenizer config and checkpoint files
   *    - Configure tokenizer path in the model
   *    - Create a FastAPI server that wraps the inference pipeline
   * 
   * 2. Server endpoint should accept:
   *    POST /generate_audio
   *    {
   *      "text": "Input text to convert to speech",
   *      "language": "en-ng|ig|yo|ha", 
   *      "speaker": "default"
   *    }
   * 
   * 3. Server should return:
   *    {
   *      "text": "Original or processed text",
   *      "audio_url": "http://server/generated_audio.wav"
   *    }
   * 
   * 4. Replace generateResponse method with:
   *    - HTTP POST to your YarnGPT server
   *    - Handle audio file download/caching
   *    - Error handling for server unavailability
   * 
   * 5. Update this method signature to match real API:
   *    Future<Map<String, dynamic>> generateResponse({
   *      required String text,
   *      required String language,
   *      String speaker = 'default',
   *      String serverUrl = 'http://localhost:8000',
   *    })
   * 
   * Example real implementation:
   * ```dart
   * final response = await http.post(
   *   Uri.parse('$serverUrl/generate_audio'),
   *   headers: {'Content-Type': 'application/json'},
   *   body: jsonEncode({
   *     'text': text,
   *     'language': language,
   *     'speaker': speaker,
   *   }),
   * );
   * return jsonDecode(response.body);
   * ```
   */
}