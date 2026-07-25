// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grammar_rule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GrammarRuleModel {

@JsonKey(includeToJson: false) String get id;@JsonKey(name: 'g_id') int get gId; String get title;@JsonKey(name: 'rule_type') GrammarRuleType get ruleType; Map<String, dynamic> get paradigm; Map<String, dynamic> get explanation; List<Map<String, dynamic>> get examples;
/// Create a copy of GrammarRuleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrammarRuleModelCopyWith<GrammarRuleModel> get copyWith => _$GrammarRuleModelCopyWithImpl<GrammarRuleModel>(this as GrammarRuleModel, _$identity);

  /// Serializes this GrammarRuleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrammarRuleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.gId, gId) || other.gId == gId)&&(identical(other.title, title) || other.title == title)&&(identical(other.ruleType, ruleType) || other.ruleType == ruleType)&&const DeepCollectionEquality().equals(other.paradigm, paradigm)&&const DeepCollectionEquality().equals(other.explanation, explanation)&&const DeepCollectionEquality().equals(other.examples, examples));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gId,title,ruleType,const DeepCollectionEquality().hash(paradigm),const DeepCollectionEquality().hash(explanation),const DeepCollectionEquality().hash(examples));

@override
String toString() {
  return 'GrammarRuleModel(id: $id, gId: $gId, title: $title, ruleType: $ruleType, paradigm: $paradigm, explanation: $explanation, examples: $examples)';
}


}

/// @nodoc
abstract mixin class $GrammarRuleModelCopyWith<$Res>  {
  factory $GrammarRuleModelCopyWith(GrammarRuleModel value, $Res Function(GrammarRuleModel) _then) = _$GrammarRuleModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'g_id') int gId, String title,@JsonKey(name: 'rule_type') GrammarRuleType ruleType, Map<String, dynamic> paradigm, Map<String, dynamic> explanation, List<Map<String, dynamic>> examples
});




}
/// @nodoc
class _$GrammarRuleModelCopyWithImpl<$Res>
    implements $GrammarRuleModelCopyWith<$Res> {
  _$GrammarRuleModelCopyWithImpl(this._self, this._then);

  final GrammarRuleModel _self;
  final $Res Function(GrammarRuleModel) _then;

/// Create a copy of GrammarRuleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gId = null,Object? title = null,Object? ruleType = null,Object? paradigm = null,Object? explanation = null,Object? examples = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gId: null == gId ? _self.gId : gId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,ruleType: null == ruleType ? _self.ruleType : ruleType // ignore: cast_nullable_to_non_nullable
as GrammarRuleType,paradigm: null == paradigm ? _self.paradigm : paradigm // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,examples: null == examples ? _self.examples : examples // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}

}


/// Adds pattern-matching-related methods to [GrammarRuleModel].
extension GrammarRuleModelPatterns on GrammarRuleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrammarRuleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrammarRuleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrammarRuleModel value)  $default,){
final _that = this;
switch (_that) {
case _GrammarRuleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrammarRuleModel value)?  $default,){
final _that = this;
switch (_that) {
case _GrammarRuleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'g_id')  int gId,  String title, @JsonKey(name: 'rule_type')  GrammarRuleType ruleType,  Map<String, dynamic> paradigm,  Map<String, dynamic> explanation,  List<Map<String, dynamic>> examples)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrammarRuleModel() when $default != null:
return $default(_that.id,_that.gId,_that.title,_that.ruleType,_that.paradigm,_that.explanation,_that.examples);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'g_id')  int gId,  String title, @JsonKey(name: 'rule_type')  GrammarRuleType ruleType,  Map<String, dynamic> paradigm,  Map<String, dynamic> explanation,  List<Map<String, dynamic>> examples)  $default,) {final _that = this;
switch (_that) {
case _GrammarRuleModel():
return $default(_that.id,_that.gId,_that.title,_that.ruleType,_that.paradigm,_that.explanation,_that.examples);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'g_id')  int gId,  String title, @JsonKey(name: 'rule_type')  GrammarRuleType ruleType,  Map<String, dynamic> paradigm,  Map<String, dynamic> explanation,  List<Map<String, dynamic>> examples)?  $default,) {final _that = this;
switch (_that) {
case _GrammarRuleModel() when $default != null:
return $default(_that.id,_that.gId,_that.title,_that.ruleType,_that.paradigm,_that.explanation,_that.examples);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrammarRuleModel implements GrammarRuleModel {
  const _GrammarRuleModel({@JsonKey(includeToJson: false) required this.id, @JsonKey(name: 'g_id') required this.gId, required this.title, @JsonKey(name: 'rule_type') required this.ruleType, final  Map<String, dynamic> paradigm = const <String, dynamic>{}, final  Map<String, dynamic> explanation = const <String, dynamic>{}, final  List<Map<String, dynamic>> examples = const <Map<String, dynamic>>[]}): _paradigm = paradigm,_explanation = explanation,_examples = examples;
  factory _GrammarRuleModel.fromJson(Map<String, dynamic> json) => _$GrammarRuleModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey(name: 'g_id') final  int gId;
@override final  String title;
@override@JsonKey(name: 'rule_type') final  GrammarRuleType ruleType;
 final  Map<String, dynamic> _paradigm;
@override@JsonKey() Map<String, dynamic> get paradigm {
  if (_paradigm is EqualUnmodifiableMapView) return _paradigm;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_paradigm);
}

 final  Map<String, dynamic> _explanation;
@override@JsonKey() Map<String, dynamic> get explanation {
  if (_explanation is EqualUnmodifiableMapView) return _explanation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_explanation);
}

 final  List<Map<String, dynamic>> _examples;
@override@JsonKey() List<Map<String, dynamic>> get examples {
  if (_examples is EqualUnmodifiableListView) return _examples;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_examples);
}


/// Create a copy of GrammarRuleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrammarRuleModelCopyWith<_GrammarRuleModel> get copyWith => __$GrammarRuleModelCopyWithImpl<_GrammarRuleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrammarRuleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrammarRuleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.gId, gId) || other.gId == gId)&&(identical(other.title, title) || other.title == title)&&(identical(other.ruleType, ruleType) || other.ruleType == ruleType)&&const DeepCollectionEquality().equals(other._paradigm, _paradigm)&&const DeepCollectionEquality().equals(other._explanation, _explanation)&&const DeepCollectionEquality().equals(other._examples, _examples));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gId,title,ruleType,const DeepCollectionEquality().hash(_paradigm),const DeepCollectionEquality().hash(_explanation),const DeepCollectionEquality().hash(_examples));

@override
String toString() {
  return 'GrammarRuleModel(id: $id, gId: $gId, title: $title, ruleType: $ruleType, paradigm: $paradigm, explanation: $explanation, examples: $examples)';
}


}

/// @nodoc
abstract mixin class _$GrammarRuleModelCopyWith<$Res> implements $GrammarRuleModelCopyWith<$Res> {
  factory _$GrammarRuleModelCopyWith(_GrammarRuleModel value, $Res Function(_GrammarRuleModel) _then) = __$GrammarRuleModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'g_id') int gId, String title,@JsonKey(name: 'rule_type') GrammarRuleType ruleType, Map<String, dynamic> paradigm, Map<String, dynamic> explanation, List<Map<String, dynamic>> examples
});




}
/// @nodoc
class __$GrammarRuleModelCopyWithImpl<$Res>
    implements _$GrammarRuleModelCopyWith<$Res> {
  __$GrammarRuleModelCopyWithImpl(this._self, this._then);

  final _GrammarRuleModel _self;
  final $Res Function(_GrammarRuleModel) _then;

/// Create a copy of GrammarRuleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gId = null,Object? title = null,Object? ruleType = null,Object? paradigm = null,Object? explanation = null,Object? examples = null,}) {
  return _then(_GrammarRuleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gId: null == gId ? _self.gId : gId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,ruleType: null == ruleType ? _self.ruleType : ruleType // ignore: cast_nullable_to_non_nullable
as GrammarRuleType,paradigm: null == paradigm ? _self._paradigm : paradigm // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,explanation: null == explanation ? _self._explanation : explanation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,examples: null == examples ? _self._examples : examples // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}


}

// dart format on
