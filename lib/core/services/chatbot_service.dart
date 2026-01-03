import 'package:firebase_ai/firebase_ai.dart';
import 'package:mess_manager/core/models/member.dart';

/// ChatbotService - Firebase AI Logic powered mess assistant
///
/// Uses Firebase AI Logic (Gemini via Firebase) to answer user queries about:
/// - Balance and debt explanations
/// - Meal costs and rates
/// - General mess-related questions
class ChatbotService {
  static ChatbotService? _instance;
  GenerativeModel? _model;
  ChatSession? _chat;
  bool _isInitialized = false;

  ChatbotService._();

  static ChatbotService get instance {
    _instance ??= ChatbotService._();
    return _instance!;
  }

  /// Initialize Gemini via Firebase AI Logic
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Initialize via Firebase AI Logic (no API key needed - uses Firebase auth)
      _model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');

      _isInitialized = true;
    } catch (e) {
      // Fail silently - chatbot will show placeholder
      _isInitialized = false;
    }
  }

  /// Start a new chat session with context
  void startChat({
    required Member currentMember,
    required double balance,
    required int mealCount,
    required double mealRate,
    required double bazarTotal,
    required int memberCount,
  }) {
    if (!_isInitialized || _model == null) return;

    final systemPrompt = _buildSystemPrompt(
      member: currentMember,
      balance: balance,
      mealCount: mealCount,
      mealRate: mealRate,
      bazarTotal: bazarTotal,
      memberCount: memberCount,
    );

    _chat = _model!.startChat(
      history: [
        Content.text(systemPrompt),
        Content.model([
          TextPart(
            'বুঝেছি! আমি আপনার মেস সংক্রান্ত প্রশ্নের উত্তর দিতে প্রস্তুত। কিভাবে সাহায্য করতে পারি?',
          ),
        ]),
      ],
    );
  }

  /// Build system prompt with user context
  String _buildSystemPrompt({
    required Member member,
    required double balance,
    required int mealCount,
    required double mealRate,
    required double bazarTotal,
    required int memberCount,
  }) {
    final isPositive = balance >= 0;
    final balanceStatus = isPositive ? 'জমা আছে' : 'বাকি আছে';

    return '''
You are a helpful mess (shared living) finance assistant named "Area51 AI".
Your job is to help users understand their mess finances.

CONTEXT (Current User):
- Name: ${member.name}
- Role: ${member.role.name}
- Current Balance: ৳${balance.abs().toStringAsFixed(0)} ($balanceStatus)
- This month:
  - Meals eaten: $mealCount meals
  - Meal rate: ৳${mealRate.toStringAsFixed(1)}/meal
  - Bazar contribution: ৳${bazarTotal.toStringAsFixed(0)}
  - Total members: $memberCount

RULES:
1. Keep responses SHORT (2-3 sentences max)
2. Use Bengali-English mix naturally (like Bangladeshi conversation)
3. Be friendly and helpful
4. Explain finances simply
5. If balance is negative, explain why kindly
6. Never make up numbers - use only the context provided
7. If asked about something you don't know, say so

EXAMPLES:
User: কেন আমার টাকা কমে গেছে?
Assistant: আপনি এই মাসে $mealCount বার খেয়েছেন, প্রতি মিল ৳${mealRate.toStringAsFixed(0)} রেটে। তাই মোট খরচ হয়েছে ৳${(mealCount * mealRate).toStringAsFixed(0)}। কিন্তু বাজারে দিয়েছেন ৳$bazarTotal, তাই ব্যালেন্স ${isPositive ? 'জমা' : 'বাকি'}।

User: মিল রেট এত বেশি কেন?
Assistant: এই মাসে মিল রেট ৳${mealRate.toStringAsFixed(1)} কারণ বাজারের জিনিসপত্রের দাম বেশি ছিল। জিনিসপত্রের দাম কমলে রেটও কমবে।
''';
  }

  /// Send message and get AI response
  Future<String> sendMessage(String message) async {
    if (!_isInitialized || _chat == null) {
      return 'AI Assistant এখনো সেটআপ হয়নি। অনুগ্রহ করে পরে চেষ্টা করুন।';
    }

    try {
      final response = await _chat!.sendMessage(Content.text(message));
      return response.text ?? 'দুঃখিত, উত্তর দিতে সমস্যা হচ্ছে।';
    } catch (e) {
      return 'দুঃখিত, একটি সমস্যা হয়েছে। পরে আবার চেষ্টা করুন।';
    }
  }

  /// Get quick suggestion chips
  List<String> get suggestions => [
    'কেন আমার টাকা কমে গেছে?',
    'এই মাসে মিল রেট কত?',
    'আমার ব্যালেন্স কত?',
    'কে সবচেয়ে বেশি বাজার করেছে?',
    'আমি কত বার খেয়েছি?',
  ];

  bool get isReady => _isInitialized && _model != null;
}
