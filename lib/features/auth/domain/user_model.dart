// ignore_for_file: invalid_annotation_target
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    // id берётся из DocumentSnapshot.id, поэтому в toJson() не включается
    @JsonKey(includeToJson: false) required String id,
    required String email,
    String? displayName,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Создаёт модель из Firestore-документа.
  /// id берётся из [doc.id], не из тела документа.
  static UserModel fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserModel.fromJson({'id': doc.id, ...?doc.data()});
  }
}
