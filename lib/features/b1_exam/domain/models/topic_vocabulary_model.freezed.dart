// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic_vocabulary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TopicVocabularyModel {

@JsonKey(includeToJson: false) String get id;@JsonKey(name: 'voc_id') int get vocId; String get word; Map<String, dynamic> get translation; String get transcription; String? get gender;@JsonKey(name: 'example_sentence') Map<String, dynamic> get exampleSentence;@JsonKey(name: 'audio_url') String? get audioUrl;
/// Create a copy of TopicVocabularyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicVocabularyModelCopyWith<TopicVocabularyModel> get copyWith => _$TopicVocabularyModelCopyWithImpl<TopicVocabularyModel>(this as TopicVocabularyModel, _$identity);

  /// Serializes this TopicVocabularyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopicVocabularyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.vocId, vocId) || other.vocId == vocId)&&(identical(other.word, word) || other.word == word)&&const DeepCollectionEquality().equals(other.translation, translation)&&(identical(other.transcription, transcription) || other.transcription == transcription)&&(identical(other.gender, gender) || other.gender == gender)&&const DeepCollectionEquality().equals(other.exampleSentence, exampleSentence)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vocId,word,const DeepCollectionEquality().hash(translation),transcription,gender,const DeepCollectionEquality().hash(exampleSentence),audioUrl);

@override
String toString() {
  return 'TopicVocabularyModel(id: $id, vocId: $vocId, word: $word, translation: $translation, transcription: $transcription, gender: $gender, exampleSentence: $exampleSentence, audioUrl: $audioUrl)';
}


}

/// @nodoc
abstract mixin class $TopicVocabularyModelCopyWith<$Res>  {
  factory $TopicVocabularyModelCopyWith(TopicVocabularyModel value, $Res Function(TopicVocabularyModel) _then) = _$TopicVocabularyModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'voc_id') int vocId, String word, Map<String, dynamic> translation, String transcription, String? gender,@JsonKey(name: 'example_sentence') Map<String, dynamic> exampleSentence,@JsonKey(name: 'audio_url') String? audioUrl
});




}
/// @nodoc
class _$TopicVocabularyModelCopyWithImpl<$Res>
    implements $TopicVocabularyModelCopyWith<$Res> {
  _$TopicVocabularyModelCopyWithImpl(this._self, this._then);

  final TopicVocabularyModel _self;
  final $Res Function(TopicVocabularyModel) _then;

/// Create a copy of TopicVocabularyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vocId = null,Object? word = null,Object? translation = null,Object? transcription = null,Object? gender = freezed,Object? exampleSentence = null,Object? audioUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vocId: null == vocId ? _self.vocId : vocId // ignore: cast_nullable_to_non_nullable
as int,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,transcription: null == transcription ? _self.transcription : transcription // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,exampleSentence: null == exampleSentence ? _self.exampleSentence : exampleSentence // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TopicVocabularyModel].
extension TopicVocabularyModelPatterns on TopicVocabularyModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopicVocabularyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopicVocabularyModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopicVocabularyModel value)  $default,){
final _that = this;
switch (_that) {
case _TopicVocabularyModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopicVocabularyModel value)?  $default,){
final _that = this;
switch (_that) {
case _TopicVocabularyModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'voc_id')  int vocId,  String word,  Map<String, dynamic> translation,  String transcription,  String? gender, @JsonKey(name: 'example_sentence')  Map<String, dynamic> exampleSentence, @JsonKey(name: 'audio_url')  String? audioUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopicVocabularyModel() when $default != null:
return $default(_that.id,_that.vocId,_that.word,_that.translation,_that.transcription,_that.gender,_that.exampleSentence,_that.audioUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'voc_id')  int vocId,  String word,  Map<String, dynamic> translation,  String transcription,  String? gender, @JsonKey(name: 'example_sentence')  Map<String, dynamic> exampleSentence, @JsonKey(name: 'audio_url')  String? audioUrl)  $default,) {final _that = this;
switch (_that) {
case _TopicVocabularyModel():
return $default(_that.id,_that.vocId,_that.word,_that.translation,_that.transcription,_that.gender,_that.exampleSentence,_that.audioUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'voc_id')  int vocId,  String word,  Map<String, dynamic> translation,  String transcription,  String? gender, @JsonKey(name: 'example_sentence')  Map<String, dynamic> exampleSentence, @JsonKey(name: 'audio_url')  String? audioUrl)?  $default,) {final _that = this;
switch (_that) {
case _TopicVocabularyModel() when $default != null:
return $default(_that.id,_that.vocId,_that.word,_that.translation,_that.transcription,_that.gender,_that.exampleSentence,_that.audioUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopicVocabularyModel implements TopicVocabularyModel {
  const _TopicVocabularyModel({@JsonKey(includeToJson: false) required this.id, @JsonKey(name: 'voc_id') required this.vocId, required this.word, final  Map<String, dynamic> translation = const <String, dynamic>{}, this.transcription = '', this.gender, @JsonKey(name: 'example_sentence') final  Map<String, dynamic> exampleSentence = const <String, dynamic>{}, @JsonKey(name: 'audio_url') this.audioUrl}): _translation = translation,_exampleSentence = exampleSentence;
  factory _TopicVocabularyModel.fromJson(Map<String, dynamic> json) => _$TopicVocabularyModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey(name: 'voc_id') final  int vocId;
@override final  String word;
 final  Map<String, dynamic> _translation;
@override@JsonKey() Map<String, dynamic> get translation {
  if (_translation is EqualUnmodifiableMapView) return _translation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_translation);
}

@override@JsonKey() final  String transcription;
@override final  String? gender;
 final  Map<String, dynamic> _exampleSentence;
@override@JsonKey(name: 'example_sentence') Map<String, dynamic> get exampleSentence {
  if (_exampleSentence is EqualUnmodifiableMapView) return _exampleSentence;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_exampleSentence);
}

@override@JsonKey(name: 'audio_url') final  String? audioUrl;

/// Create a copy of TopicVocabularyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicVocabularyModelCopyWith<_TopicVocabularyModel> get copyWith => __$TopicVocabularyModelCopyWithImpl<_TopicVocabularyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopicVocabularyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopicVocabularyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.vocId, vocId) || other.vocId == vocId)&&(identical(other.word, word) || other.word == word)&&const DeepCollectionEquality().equals(other._translation, _translation)&&(identical(other.transcription, transcription) || other.transcription == transcription)&&(identical(other.gender, gender) || other.gender == gender)&&const DeepCollectionEquality().equals(other._exampleSentence, _exampleSentence)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vocId,word,const DeepCollectionEquality().hash(_translation),transcription,gender,const DeepCollectionEquality().hash(_exampleSentence),audioUrl);

@override
String toString() {
  return 'TopicVocabularyModel(id: $id, vocId: $vocId, word: $word, translation: $translation, transcription: $transcription, gender: $gender, exampleSentence: $exampleSentence, audioUrl: $audioUrl)';
}


}

/// @nodoc
abstract mixin class _$TopicVocabularyModelCopyWith<$Res> implements $TopicVocabularyModelCopyWith<$Res> {
  factory _$TopicVocabularyModelCopyWith(_TopicVocabularyModel value, $Res Function(_TopicVocabularyModel) _then) = __$TopicVocabularyModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'voc_id') int vocId, String word, Map<String, dynamic> translation, String transcription, String? gender,@JsonKey(name: 'example_sentence') Map<String, dynamic> exampleSentence,@JsonKey(name: 'audio_url') String? audioUrl
});




}
/// @nodoc
class __$TopicVocabularyModelCopyWithImpl<$Res>
    implements _$TopicVocabularyModelCopyWith<$Res> {
  __$TopicVocabularyModelCopyWithImpl(this._self, this._then);

  final _TopicVocabularyModel _self;
  final $Res Function(_TopicVocabularyModel) _then;

/// Create a copy of TopicVocabularyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vocId = null,Object? word = null,Object? translation = null,Object? transcription = null,Object? gender = freezed,Object? exampleSentence = null,Object? audioUrl = freezed,}) {
  return _then(_TopicVocabularyModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vocId: null == vocId ? _self.vocId : vocId // ignore: cast_nullable_to_non_nullable
as int,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self._translation : translation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,transcription: null == transcription ? _self.transcription : transcription // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,exampleSentence: null == exampleSentence ? _self._exampleSentence : exampleSentence // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
