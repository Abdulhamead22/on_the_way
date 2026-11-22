import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  late final String _apiKey;

  GeminiService() {
    _apiKey = (dotenv.env['GEMINI_API_KEY'] ?? '').trim();
  }

  Future<List<Map<String, dynamic>>> parseOrderPrompt(String userPrompt) async {
    if (_apiKey.isNotEmpty && _apiKey != 'YOUR_GEMINI_API_KEY') {
      final onlineResult = await _tryGoogleAiModels(userPrompt);
      if (onlineResult != null && onlineResult.isNotEmpty) {
        return onlineResult;
      }
    }

    debugPrint('⚠️ تم استخدام المحلل المحلي الاحتياطي بسبب انشغال السيرفر');
    return _smartLocalParser(userPrompt);
  }

  Future<List<Map<String, dynamic>>?> _tryGoogleAiModels(
    String userPrompt,
  ) async {
    final prompt =
        '''
أنت مساعد ذكي لتطبيق توصيل طلبات ومهام في فلسطين.
المستخدم كتب الطلب التالي: "$userPrompt"
استنتج الأغراض المناسبة لهذا الطلب بدقة (سواء كانت طعاماً، ملابس، أدوية، إلكترونيات، أو أي مهام أخرى) وقدّر الكمية والسعر الواقعي بالشيكل الإسرائيلي (ILS).
أرجع النتيجة كـ JSON Array فقط، كل عنصر يحتوي على:
{"name": "اسم الغرض بالعربية", "quantity": "الكمية والوحدة", "price": 15.0}
''';

    final models = ['gemini-3.5-flash-lite', 'gemini-3.8-flash'];

    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      for (final model in models) {
        try {
          // 1. تم تصحيح الرابط الكامل لـ Gemini API
          final uri = Uri.https(
            'generativelanguage.googleapis.com',
            '/v1beta/models/$model:generateContent',
          );

          final request = await client.postUrl(uri);
          request.headers.contentType = ContentType.json;
          request.headers.add('X-goog-api-key', _apiKey);
          request.add(
            utf8.encode(
              jsonEncode({
                'contents': [
                  {
                    'parts': [
                      {'text': prompt},
                    ],
                  },
                ],
                'generationConfig': {
                  'temperature': 0.3,
                  // 2. إجبار النموذج على إرجاع JSON نقي
                  'responseMimeType': 'application/json',
                },
              }),
            ),
          );

          final response = await request.close().timeout(
            const Duration(seconds: 15),
          );
          final body = await response.transform(utf8.decoder).join();

          if (response.statusCode == 200) {
            final data = jsonDecode(body);
            final candidates = data['candidates'] as List<dynamic>?;
            if (candidates != null && candidates.isNotEmpty) {
              final content =
                  candidates.first['content'] as Map<String, dynamic>?;
              final parts = content?['parts'] as List<dynamic>?;
              if (parts != null && parts.isNotEmpty) {
                String text = parts.first['text']?.toString() ?? '';
                text = text
                    .replaceAll('```json', '')
                    .replaceAll('```', '')
                    .trim();
                final startIdx = text.indexOf('[');
                final endIdx = text.lastIndexOf(']');
                if (startIdx != -1 && endIdx != -1) {
                  text = text.substring(startIdx, endIdx + 1);
                }
                final List<dynamic> decoded = jsonDecode(text);
                debugPrint(
                  '✅ تم التوليد بنجاح عبر الذكاء الاصطناعي السحابي: $model',
                );
                return decoded
                    .map((e) => Map<String, dynamic>.from(e))
                    .toList();
              }
            }
          } else {
            // 3. طباعة تفاصيل الخطأ لمعرفة السبب الدقيق إن وجد
            debugPrint(
              'ℹ️ الموديل $model أعطى حالة ${response.statusCode}: $body',
            );
          }
        } catch (e) {
          debugPrint('ℹ️ تعذر الاتصال بـ $model: $e');
        }
      }
    } finally {
      client.close();
    }
    return null;
  }

  List<Map<String, dynamic>> _smartLocalParser(String prompt) {
    final parts = prompt
        .replaceAll('بدي', '')
        .replaceAll('عايز', '')
        .split(RegExp(r'[,،\n]| و '))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.length > 1) {
      return parts
          .map((item) => {'name': item, 'quantity': '1', 'price': 10.0})
          .toList();
    }
    return [
      {'name': prompt.trim(), 'quantity': '1', 'price': 15.0},
    ];
  }
}
