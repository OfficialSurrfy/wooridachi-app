import '../../domain/repositories/translation_repository.dart';
import '../datasources/translation_datasource.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  final TranslationDatasource _datasource;

  TranslationRepositoryImpl(this._datasource);

  @override
  Future<String?> translateText(String text) async {
    try {
      return await _datasource.translateText(text);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> translateChatText(String message) async {
    try {
      return await _datasource.translateChatText(message);
    } catch (e) {
      rethrow;
    }
  }
}
