abstract class TranslationRepository {
  Future<String?> translateText(String text);
  Future<String?> translateChatText(String message);
}
