import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linguobyte/core/constants/firestore_paths.dart';
import 'package:linguobyte/core/errors/app_error.dart';
import 'package:linguobyte/features/home/domain/models/language_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'language_repository.g.dart';

@riverpod
LanguageRepository languageRepository(Ref ref) =>
    LanguageRepository(FirebaseFirestore.instance);

class LanguageRepository {
  final FirebaseFirestore _firestore;

  const LanguageRepository(this._firestore);

  /// Загружает все доступные языки из коллекции basic/.
  Future<List<LanguageModel>> getLanguages() async {
    try {
      final snapshot =
          await _firestore.collection(FirestorePaths.basic).get();
      return snapshot.docs
          .map((doc) => LanguageModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw UnknownError(e.toString());
    }
  }
}
