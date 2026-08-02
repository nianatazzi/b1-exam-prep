// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misused_word_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MisusedWordModel {

 String get word; MisusedWordType get type;@JsonKey(name: 'userForm') String get userForm;@JsonKey(name: 'correctForm') String get correctForm; String get explanation;
/// Create a copy of MisusedWordModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisusedWordModelCopyWith<MisusedWordModel> get copyWith => _$MisusedWordModelCopyWithImpl<MisusedWordModel>(this as MisusedWordModel, _$identity);

  /// Serializes this MisusedWordModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisusedWordModel&&(identical(other.word, word) || other.word == word)&&(identical(other.type, type) || other.type == type)&&(identical(other.userForm, userForm) || other.userForm == userForm)&&(identical(other.correctForm, correctForm) || other.correctForm == correctForm)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,type,userForm,correctForm,explanation);

@override
String toString() {
  return 'MisusedWordModel(word: $word, type: $type, userForm: $userForm, correctForm: $correctForm, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class $MisusedWordModelCopyWith<$Res>  {
  factory $MisusedWordModelCopyWith(MisusedWordModel value, $Res Function(MisusedWordModel) _then) = _$MisusedWordModelCopyWithImpl;
@useResult
$Res call({
 String word, MisusedWordType type,@JsonKey(name: 'userForm') String userForm,@JsonKey(name: 'correctForm') String correctForm, String explanation
});




}
/// @nodoc
class _$MisusedWordModelCopyWithImpl<$Res>
    implements $MisusedWordModelCopyWith<$Res> {
  _$MisusedWordModelCopyWithImpl(this._self, this._then);

  final MisusedWordModel _self;
  final $Res Function(MisusedWordModel) _then;

/// Create a copy of MisusedWordModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = null,Object? type = null,Object? userForm = null,Object? correctForm = null,Object? explanation = null,}) {
  return _then(_self.copyWith(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MisusedWordType,userForm: null == userForm ? _self.userForm : userForm // ignore: cast_nullable_to_non_nullable
as String,correctForm: null == correctForm ? _self.correctForm : correctForm // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MisusedWordModel].
extension MisusedWordModelPatterns on MisusedWordModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MisusedWordModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MisusedWordModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MisusedWordModel value)  $default,){
final _that = this;
switch (_that) {
case _MisusedWordModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MisusedWordModel value)?  $default,){
final _that = this;
switch (_that) {
case _MisusedWordModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String word,  MisusedWordType type, @JsonKey(name: 'userForm')  String userForm, @JsonKey(name: 'correctForm')  String correctForm,  String explanation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MisusedWordModel() when $default != null:
return $default(_that.word,_that.type,_that.userForm,_that.correctForm,_that.explanation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String word,  MisusedWordType type, @JsonKey(name: 'userForm')  String userForm, @JsonKey(name: 'correctForm')  String correctForm,  String explanation)  $default,) {final _that = this;
switch (_that) {
case _MisusedWordModel():
return $default(_that.word,_that.type,_that.userForm,_that.correctForm,_that.explanation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String word,  MisusedWordType type, @JsonKey(name: 'userForm')  String userForm, @JsonKey(name: 'correctForm')  String correctForm,  String explanation)?  $default,) {final _that = this;
switch (_that) {
case _MisusedWordModel() when $default != null:
return $default(_that.word,_that.type,_that.userForm,_that.correctForm,_that.explanation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MisusedWordModel implements MisusedWordModel {
  const _MisusedWordModel({required this.word, required this.type, @JsonKey(name: 'userForm') required this.userForm, @JsonKey(name: 'correctForm') required this.correctForm, this.explanation = ''});
  factory _MisusedWordModel.fromJson(Map<String, dynamic> json) => _$MisusedWordModelFromJson(json);

@override final  String word;
@override final  MisusedWordType type;
@override@JsonKey(name: 'userForm') final  String userForm;
@override@JsonKey(name: 'correctForm') final  String correctForm;
@override@JsonKey() final  String explanation;

/// Create a copy of MisusedWordModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MisusedWordModelCopyWith<_MisusedWordModel> get copyWith => __$MisusedWordModelCopyWithImpl<_MisusedWordModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MisusedWordModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MisusedWordModel&&(identical(other.word, word) || other.word == word)&&(identical(other.type, type) || other.type == type)&&(identical(other.userForm, userForm) || other.userForm == userForm)&&(identical(other.correctForm, correctForm) || other.correctForm == correctForm)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,type,userForm,correctForm,explanation);

@override
String toString() {
  return 'MisusedWordModel(word: $word, type: $type, userForm: $userForm, correctForm: $correctForm, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class _$MisusedWordModelCopyWith<$Res> implements $MisusedWordModelCopyWith<$Res> {
  factory _$MisusedWordModelCopyWith(_MisusedWordModel value, $Res Function(_MisusedWordModel) _then) = __$MisusedWordModelCopyWithImpl;
@override @useResult
$Res call({
 String word, MisusedWordType type,@JsonKey(name: 'userForm') String userForm,@JsonKey(name: 'correctForm') String correctForm, String explanation
});




}
/// @nodoc
class __$MisusedWordModelCopyWithImpl<$Res>
    implements _$MisusedWordModelCopyWith<$Res> {
  __$MisusedWordModelCopyWithImpl(this._self, this._then);

  final _MisusedWordModel _self;
  final $Res Function(_MisusedWordModel) _then;

/// Create a copy of MisusedWordModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = null,Object? type = null,Object? userForm = null,Object? correctForm = null,Object? explanation = null,}) {
  return _then(_MisusedWordModel(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MisusedWordType,userForm: null == userForm ? _self.userForm : userForm // ignore: cast_nullable_to_non_nullable
as String,correctForm: null == correctForm ? _self.correctForm : correctForm // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
