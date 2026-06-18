// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_language_progress_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserLanguageProgressModel {

// id берётся из DocumentSnapshot.id — не хранится в теле документа
@JsonKey(includeToJson: false) String get id;// null = новый пользователь, все уроки locked
 String? get lastLesson; int get lastParagraph;// @Default(0) — документ прогресса может быть создан частично (updateProgress
// пишет только lastLesson/lastParagraph). Эти поля — заглушки детального
// прогресса; реальные значения, когда появятся, читаются как обычно.
@JsonKey(name: 'oral_progress') int get oralProgress;@JsonKey(name: 'grammar_progress') int get grammarProgress;@JsonKey(name: 'lexicon_progress') int get lexiconProgress;
/// Create a copy of UserLanguageProgressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserLanguageProgressModelCopyWith<UserLanguageProgressModel> get copyWith => _$UserLanguageProgressModelCopyWithImpl<UserLanguageProgressModel>(this as UserLanguageProgressModel, _$identity);

  /// Serializes this UserLanguageProgressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserLanguageProgressModel&&(identical(other.id, id) || other.id == id)&&(identical(other.lastLesson, lastLesson) || other.lastLesson == lastLesson)&&(identical(other.lastParagraph, lastParagraph) || other.lastParagraph == lastParagraph)&&(identical(other.oralProgress, oralProgress) || other.oralProgress == oralProgress)&&(identical(other.grammarProgress, grammarProgress) || other.grammarProgress == grammarProgress)&&(identical(other.lexiconProgress, lexiconProgress) || other.lexiconProgress == lexiconProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lastLesson,lastParagraph,oralProgress,grammarProgress,lexiconProgress);

@override
String toString() {
  return 'UserLanguageProgressModel(id: $id, lastLesson: $lastLesson, lastParagraph: $lastParagraph, oralProgress: $oralProgress, grammarProgress: $grammarProgress, lexiconProgress: $lexiconProgress)';
}


}

/// @nodoc
abstract mixin class $UserLanguageProgressModelCopyWith<$Res>  {
  factory $UserLanguageProgressModelCopyWith(UserLanguageProgressModel value, $Res Function(UserLanguageProgressModel) _then) = _$UserLanguageProgressModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String? lastLesson, int lastParagraph,@JsonKey(name: 'oral_progress') int oralProgress,@JsonKey(name: 'grammar_progress') int grammarProgress,@JsonKey(name: 'lexicon_progress') int lexiconProgress
});




}
/// @nodoc
class _$UserLanguageProgressModelCopyWithImpl<$Res>
    implements $UserLanguageProgressModelCopyWith<$Res> {
  _$UserLanguageProgressModelCopyWithImpl(this._self, this._then);

  final UserLanguageProgressModel _self;
  final $Res Function(UserLanguageProgressModel) _then;

/// Create a copy of UserLanguageProgressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lastLesson = freezed,Object? lastParagraph = null,Object? oralProgress = null,Object? grammarProgress = null,Object? lexiconProgress = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lastLesson: freezed == lastLesson ? _self.lastLesson : lastLesson // ignore: cast_nullable_to_non_nullable
as String?,lastParagraph: null == lastParagraph ? _self.lastParagraph : lastParagraph // ignore: cast_nullable_to_non_nullable
as int,oralProgress: null == oralProgress ? _self.oralProgress : oralProgress // ignore: cast_nullable_to_non_nullable
as int,grammarProgress: null == grammarProgress ? _self.grammarProgress : grammarProgress // ignore: cast_nullable_to_non_nullable
as int,lexiconProgress: null == lexiconProgress ? _self.lexiconProgress : lexiconProgress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserLanguageProgressModel].
extension UserLanguageProgressModelPatterns on UserLanguageProgressModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserLanguageProgressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserLanguageProgressModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserLanguageProgressModel value)  $default,){
final _that = this;
switch (_that) {
case _UserLanguageProgressModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserLanguageProgressModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserLanguageProgressModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String? lastLesson,  int lastParagraph, @JsonKey(name: 'oral_progress')  int oralProgress, @JsonKey(name: 'grammar_progress')  int grammarProgress, @JsonKey(name: 'lexicon_progress')  int lexiconProgress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserLanguageProgressModel() when $default != null:
return $default(_that.id,_that.lastLesson,_that.lastParagraph,_that.oralProgress,_that.grammarProgress,_that.lexiconProgress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String? lastLesson,  int lastParagraph, @JsonKey(name: 'oral_progress')  int oralProgress, @JsonKey(name: 'grammar_progress')  int grammarProgress, @JsonKey(name: 'lexicon_progress')  int lexiconProgress)  $default,) {final _that = this;
switch (_that) {
case _UserLanguageProgressModel():
return $default(_that.id,_that.lastLesson,_that.lastParagraph,_that.oralProgress,_that.grammarProgress,_that.lexiconProgress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String? lastLesson,  int lastParagraph, @JsonKey(name: 'oral_progress')  int oralProgress, @JsonKey(name: 'grammar_progress')  int grammarProgress, @JsonKey(name: 'lexicon_progress')  int lexiconProgress)?  $default,) {final _that = this;
switch (_that) {
case _UserLanguageProgressModel() when $default != null:
return $default(_that.id,_that.lastLesson,_that.lastParagraph,_that.oralProgress,_that.grammarProgress,_that.lexiconProgress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserLanguageProgressModel implements UserLanguageProgressModel {
  const _UserLanguageProgressModel({@JsonKey(includeToJson: false) required this.id, this.lastLesson, required this.lastParagraph, @JsonKey(name: 'oral_progress') this.oralProgress = 0, @JsonKey(name: 'grammar_progress') this.grammarProgress = 0, @JsonKey(name: 'lexicon_progress') this.lexiconProgress = 0});
  factory _UserLanguageProgressModel.fromJson(Map<String, dynamic> json) => _$UserLanguageProgressModelFromJson(json);

// id берётся из DocumentSnapshot.id — не хранится в теле документа
@override@JsonKey(includeToJson: false) final  String id;
// null = новый пользователь, все уроки locked
@override final  String? lastLesson;
@override final  int lastParagraph;
// @Default(0) — документ прогресса может быть создан частично (updateProgress
// пишет только lastLesson/lastParagraph). Эти поля — заглушки детального
// прогресса; реальные значения, когда появятся, читаются как обычно.
@override@JsonKey(name: 'oral_progress') final  int oralProgress;
@override@JsonKey(name: 'grammar_progress') final  int grammarProgress;
@override@JsonKey(name: 'lexicon_progress') final  int lexiconProgress;

/// Create a copy of UserLanguageProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserLanguageProgressModelCopyWith<_UserLanguageProgressModel> get copyWith => __$UserLanguageProgressModelCopyWithImpl<_UserLanguageProgressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserLanguageProgressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserLanguageProgressModel&&(identical(other.id, id) || other.id == id)&&(identical(other.lastLesson, lastLesson) || other.lastLesson == lastLesson)&&(identical(other.lastParagraph, lastParagraph) || other.lastParagraph == lastParagraph)&&(identical(other.oralProgress, oralProgress) || other.oralProgress == oralProgress)&&(identical(other.grammarProgress, grammarProgress) || other.grammarProgress == grammarProgress)&&(identical(other.lexiconProgress, lexiconProgress) || other.lexiconProgress == lexiconProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lastLesson,lastParagraph,oralProgress,grammarProgress,lexiconProgress);

@override
String toString() {
  return 'UserLanguageProgressModel(id: $id, lastLesson: $lastLesson, lastParagraph: $lastParagraph, oralProgress: $oralProgress, grammarProgress: $grammarProgress, lexiconProgress: $lexiconProgress)';
}


}

/// @nodoc
abstract mixin class _$UserLanguageProgressModelCopyWith<$Res> implements $UserLanguageProgressModelCopyWith<$Res> {
  factory _$UserLanguageProgressModelCopyWith(_UserLanguageProgressModel value, $Res Function(_UserLanguageProgressModel) _then) = __$UserLanguageProgressModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String? lastLesson, int lastParagraph,@JsonKey(name: 'oral_progress') int oralProgress,@JsonKey(name: 'grammar_progress') int grammarProgress,@JsonKey(name: 'lexicon_progress') int lexiconProgress
});




}
/// @nodoc
class __$UserLanguageProgressModelCopyWithImpl<$Res>
    implements _$UserLanguageProgressModelCopyWith<$Res> {
  __$UserLanguageProgressModelCopyWithImpl(this._self, this._then);

  final _UserLanguageProgressModel _self;
  final $Res Function(_UserLanguageProgressModel) _then;

/// Create a copy of UserLanguageProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lastLesson = freezed,Object? lastParagraph = null,Object? oralProgress = null,Object? grammarProgress = null,Object? lexiconProgress = null,}) {
  return _then(_UserLanguageProgressModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lastLesson: freezed == lastLesson ? _self.lastLesson : lastLesson // ignore: cast_nullable_to_non_nullable
as String?,lastParagraph: null == lastParagraph ? _self.lastParagraph : lastParagraph // ignore: cast_nullable_to_non_nullable
as int,oralProgress: null == oralProgress ? _self.oralProgress : oralProgress // ignore: cast_nullable_to_non_nullable
as int,grammarProgress: null == grammarProgress ? _self.grammarProgress : grammarProgress // ignore: cast_nullable_to_non_nullable
as int,lexiconProgress: null == lexiconProgress ? _self.lexiconProgress : lexiconProgress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
