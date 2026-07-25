// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phrase_pattern_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PhrasePatternModel {

@JsonKey(includeToJson: false) String get id;@JsonKey(name: 'p_id') int get pId; String get phrase; Map<String, dynamic> get translation;@JsonKey(name: 'usage_context') Map<String, dynamic> get usageContext; PhraseCategory get category;@JsonKey(name: 'audio_url') String? get audioUrl;
/// Create a copy of PhrasePatternModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhrasePatternModelCopyWith<PhrasePatternModel> get copyWith => _$PhrasePatternModelCopyWithImpl<PhrasePatternModel>(this as PhrasePatternModel, _$identity);

  /// Serializes this PhrasePatternModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhrasePatternModel&&(identical(other.id, id) || other.id == id)&&(identical(other.pId, pId) || other.pId == pId)&&(identical(other.phrase, phrase) || other.phrase == phrase)&&const DeepCollectionEquality().equals(other.translation, translation)&&const DeepCollectionEquality().equals(other.usageContext, usageContext)&&(identical(other.category, category) || other.category == category)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pId,phrase,const DeepCollectionEquality().hash(translation),const DeepCollectionEquality().hash(usageContext),category,audioUrl);

@override
String toString() {
  return 'PhrasePatternModel(id: $id, pId: $pId, phrase: $phrase, translation: $translation, usageContext: $usageContext, category: $category, audioUrl: $audioUrl)';
}


}

/// @nodoc
abstract mixin class $PhrasePatternModelCopyWith<$Res>  {
  factory $PhrasePatternModelCopyWith(PhrasePatternModel value, $Res Function(PhrasePatternModel) _then) = _$PhrasePatternModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'p_id') int pId, String phrase, Map<String, dynamic> translation,@JsonKey(name: 'usage_context') Map<String, dynamic> usageContext, PhraseCategory category,@JsonKey(name: 'audio_url') String? audioUrl
});




}
/// @nodoc
class _$PhrasePatternModelCopyWithImpl<$Res>
    implements $PhrasePatternModelCopyWith<$Res> {
  _$PhrasePatternModelCopyWithImpl(this._self, this._then);

  final PhrasePatternModel _self;
  final $Res Function(PhrasePatternModel) _then;

/// Create a copy of PhrasePatternModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pId = null,Object? phrase = null,Object? translation = null,Object? usageContext = null,Object? category = null,Object? audioUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pId: null == pId ? _self.pId : pId // ignore: cast_nullable_to_non_nullable
as int,phrase: null == phrase ? _self.phrase : phrase // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,usageContext: null == usageContext ? _self.usageContext : usageContext // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PhraseCategory,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PhrasePatternModel].
extension PhrasePatternModelPatterns on PhrasePatternModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhrasePatternModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhrasePatternModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhrasePatternModel value)  $default,){
final _that = this;
switch (_that) {
case _PhrasePatternModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhrasePatternModel value)?  $default,){
final _that = this;
switch (_that) {
case _PhrasePatternModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'p_id')  int pId,  String phrase,  Map<String, dynamic> translation, @JsonKey(name: 'usage_context')  Map<String, dynamic> usageContext,  PhraseCategory category, @JsonKey(name: 'audio_url')  String? audioUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhrasePatternModel() when $default != null:
return $default(_that.id,_that.pId,_that.phrase,_that.translation,_that.usageContext,_that.category,_that.audioUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'p_id')  int pId,  String phrase,  Map<String, dynamic> translation, @JsonKey(name: 'usage_context')  Map<String, dynamic> usageContext,  PhraseCategory category, @JsonKey(name: 'audio_url')  String? audioUrl)  $default,) {final _that = this;
switch (_that) {
case _PhrasePatternModel():
return $default(_that.id,_that.pId,_that.phrase,_that.translation,_that.usageContext,_that.category,_that.audioUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'p_id')  int pId,  String phrase,  Map<String, dynamic> translation, @JsonKey(name: 'usage_context')  Map<String, dynamic> usageContext,  PhraseCategory category, @JsonKey(name: 'audio_url')  String? audioUrl)?  $default,) {final _that = this;
switch (_that) {
case _PhrasePatternModel() when $default != null:
return $default(_that.id,_that.pId,_that.phrase,_that.translation,_that.usageContext,_that.category,_that.audioUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhrasePatternModel implements PhrasePatternModel {
  const _PhrasePatternModel({@JsonKey(includeToJson: false) required this.id, @JsonKey(name: 'p_id') required this.pId, required this.phrase, final  Map<String, dynamic> translation = const <String, dynamic>{}, @JsonKey(name: 'usage_context') final  Map<String, dynamic> usageContext = const <String, dynamic>{}, required this.category, @JsonKey(name: 'audio_url') this.audioUrl}): _translation = translation,_usageContext = usageContext;
  factory _PhrasePatternModel.fromJson(Map<String, dynamic> json) => _$PhrasePatternModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey(name: 'p_id') final  int pId;
@override final  String phrase;
 final  Map<String, dynamic> _translation;
@override@JsonKey() Map<String, dynamic> get translation {
  if (_translation is EqualUnmodifiableMapView) return _translation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_translation);
}

 final  Map<String, dynamic> _usageContext;
@override@JsonKey(name: 'usage_context') Map<String, dynamic> get usageContext {
  if (_usageContext is EqualUnmodifiableMapView) return _usageContext;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_usageContext);
}

@override final  PhraseCategory category;
@override@JsonKey(name: 'audio_url') final  String? audioUrl;

/// Create a copy of PhrasePatternModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhrasePatternModelCopyWith<_PhrasePatternModel> get copyWith => __$PhrasePatternModelCopyWithImpl<_PhrasePatternModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhrasePatternModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhrasePatternModel&&(identical(other.id, id) || other.id == id)&&(identical(other.pId, pId) || other.pId == pId)&&(identical(other.phrase, phrase) || other.phrase == phrase)&&const DeepCollectionEquality().equals(other._translation, _translation)&&const DeepCollectionEquality().equals(other._usageContext, _usageContext)&&(identical(other.category, category) || other.category == category)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pId,phrase,const DeepCollectionEquality().hash(_translation),const DeepCollectionEquality().hash(_usageContext),category,audioUrl);

@override
String toString() {
  return 'PhrasePatternModel(id: $id, pId: $pId, phrase: $phrase, translation: $translation, usageContext: $usageContext, category: $category, audioUrl: $audioUrl)';
}


}

/// @nodoc
abstract mixin class _$PhrasePatternModelCopyWith<$Res> implements $PhrasePatternModelCopyWith<$Res> {
  factory _$PhrasePatternModelCopyWith(_PhrasePatternModel value, $Res Function(_PhrasePatternModel) _then) = __$PhrasePatternModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'p_id') int pId, String phrase, Map<String, dynamic> translation,@JsonKey(name: 'usage_context') Map<String, dynamic> usageContext, PhraseCategory category,@JsonKey(name: 'audio_url') String? audioUrl
});




}
/// @nodoc
class __$PhrasePatternModelCopyWithImpl<$Res>
    implements _$PhrasePatternModelCopyWith<$Res> {
  __$PhrasePatternModelCopyWithImpl(this._self, this._then);

  final _PhrasePatternModel _self;
  final $Res Function(_PhrasePatternModel) _then;

/// Create a copy of PhrasePatternModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pId = null,Object? phrase = null,Object? translation = null,Object? usageContext = null,Object? category = null,Object? audioUrl = freezed,}) {
  return _then(_PhrasePatternModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pId: null == pId ? _self.pId : pId // ignore: cast_nullable_to_non_nullable
as int,phrase: null == phrase ? _self.phrase : phrase // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self._translation : translation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,usageContext: null == usageContext ? _self._usageContext : usageContext // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PhraseCategory,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
