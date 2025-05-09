abstract class TranslationDatasource {
  Future<String?> translateText(String text);
  Future<String?> translateChatText(String message);
}
