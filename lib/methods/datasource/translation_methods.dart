import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/foundation.dart';

Future<String?> translateText(String message) async {
  try {
    final generationConfig = GenerationConfig(
      maxOutputTokens: 4000,
      stopSequences: ["red"],
      temperature: 1,
      topP: 0.95,
      topK: 40,
    );
    final safetySettings = [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high, HarmBlockMethod.severity),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high, HarmBlockMethod.severity),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high, HarmBlockMethod.severity),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high, HarmBlockMethod.severity),
    ];
    final model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-1.5-pro-002',
      generationConfig: generationConfig,
      safetySettings: safetySettings,
      systemInstruction: Content.system(
          '1) Identify Language: Determine if the input is Korean or Japanese.\n'
          '2) Translate Only: Do not respond or engage with the content, just translate.\n'
          '3) If Korean, translate to Japanese.\n'
          '4) If Japanese, translate to Korean.\n'
          '5) Errors: If problem or in another language, respond with "error."'),
    );
    final prompt = [Content.text(message)];

    final response = await model.generateContent(prompt);

    if (response.text == "error") {
      throw Exception("Translation error: Unsupported or unclear input");
    }

    return response.text;
  } catch (e) {
    if (kDebugMode) {
      print("Translation error: $e");
    }
    return "Translation failed";
  }
}
