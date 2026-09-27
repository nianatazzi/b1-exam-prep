// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_error_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpeechErrorModel {

 String get word;@JsonKey(name: 'userForm') String get userForm;@JsonKey(name: 'correctForm') String get correctForm; String get explanation;
/// Create a copy of SpeechErrorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeechErrorModelCopyWith<SpeechErrorModel> get copyWith => _$SpeechErrorModelCopyWithImpl<SpeechErrorModel>(this as SpeechErrorModel, _$identity);

  /// Serializes this SpeechErrorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechErrorModel&&(identical(other.word, word) || other.word == word)&&(identical(other.userForm, userForm) || other.userForm == userForm)&&(identical(other.correctForm, correctForm) || other.correctForm == correctForm)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,userForm,correctForm,explanation);

@override
String toString() {
  return 'SpeechErrorModel(word: $word, userForm: $userForm, correctForm: $correctForm, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class $SpeechErrorModelCopyWith<$Res>  {
  factory $SpeechErrorModelCopyWith(SpeechErrorModel value, $Res Function(SpeechErrorModel) _then) = _$SpeechErrorModelCopyWithImpl;
@useResult
$Res call({
 String word,@JsonKey(name: 'userForm') String userForm,@JsonKey(name: 'correctForm') String correctForm, String explanation
});




}
/// @nodoc
class _$SpeechErrorModelCopyWithImpl<$Res>
    implements $SpeechErrorModelCopyWith<$Res> {
  _$SpeechErrorModelCopyWithImpl(this._self, this._then);

  final SpeechErrorModel _self;
  final $Res Function(SpeechErrorModel) _then;

/// Create a copy of SpeechErrorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = null,Object? userForm = null,Object? correctForm = null,Object? explanation = null,}) {
  return _then(_self.copyWith(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,userForm: null == userForm ? _self.userForm : userForm // ignore: cast_nullable_to_non_nullable
as String,correctForm: null == correctForm ? _self.correctForm : correctForm // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeechErrorModel].
extension SpeechErrorModelPatterns on SpeechErrorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeechErrorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeechErrorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeechErrorModel value)  $default,){
final _that = this;
switch (_that) {
case _SpeechErrorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeechErrorModel value)?  $default,){
final _that = this;
switch (_that) {
case _SpeechErrorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String word, @JsonKey(name: 'userForm')  String userForm, @JsonKey(name: 'correctForm')  String correctForm,  String explanation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeechErrorModel() when $default != null:
return $default(_that.word,_that.userForm,_that.correctForm,_that.explanation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String word, @JsonKey(name: 'userForm')  String userForm, @JsonKey(name: 'correctForm')  String correctForm,  String explanation)  $default,) {final _that = this;
switch (_that) {
case _SpeechErrorModel():
return $default(_that.word,_that.userForm,_that.correctForm,_that.explanation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String word, @JsonKey(name: 'userForm')  String userForm, @JsonKey(name: 'correctForm')  String correctForm,  String explanation)?  $default,) {final _that = this;
switch (_that) {
case _SpeechErrorModel() when $default != null:
return $default(_that.word,_that.userForm,_that.correctForm,_that.explanation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpeechErrorModel implements SpeechErrorModel {
  const _SpeechErrorModel({this.word = '', @JsonKey(name: 'userForm') this.userForm = '', @JsonKey(name: 'correctForm') this.correctForm = '', this.explanation = ''});
  factory _SpeechErrorModel.fromJson(Map<String, dynamic> json) => _$SpeechErrorModelFromJson(json);

@override@JsonKey() final  String word;
@override@JsonKey(name: 'userForm') final  String userForm;
@override@JsonKey(name: 'correctForm') final  String correctForm;
@override@JsonKey() final  String explanation;

/// Create a copy of SpeechErrorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeechErrorModelCopyWith<_SpeechErrorModel> get copyWith => __$SpeechErrorModelCopyWithImpl<_SpeechErrorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeechErrorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeechErrorModel&&(identical(other.word, word) || other.word == word)&&(identical(other.userForm, userForm) || other.userForm == userForm)&&(identical(other.correctForm, correctForm) || other.correctForm == correctForm)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,userForm,correctForm,explanation);

@override
String toString() {
  return 'SpeechErrorModel(word: $word, userForm: $userForm, correctForm: $correctForm, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class _$SpeechErrorModelCopyWith<$Res> implements $SpeechErrorModelCopyWith<$Res> {
  factory _$SpeechErrorModelCopyWith(_SpeechErrorModel value, $Res Function(_SpeechErrorModel) _then) = __$SpeechErrorModelCopyWithImpl;
@override @useResult
$Res call({
 String word,@JsonKey(name: 'userForm') String userForm,@JsonKey(name: 'correctForm') String correctForm, String explanation
});




}
/// @nodoc
class __$SpeechErrorModelCopyWithImpl<$Res>
    implements _$SpeechErrorModelCopyWith<$Res> {
  __$SpeechErrorModelCopyWithImpl(this._self, this._then);

  final _SpeechErrorModel _self;
  final $Res Function(_SpeechErrorModel) _then;

/// Create a copy of SpeechErrorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = null,Object? userForm = null,Object? correctForm = null,Object? explanation = null,}) {
  return _then(_SpeechErrorModel(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,userForm: null == userForm ? _self.userForm : userForm // ignore: cast_nullable_to_non_nullable
as String,correctForm: null == correctForm ? _self.correctForm : correctForm // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
