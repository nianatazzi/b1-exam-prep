// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_section_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExamSectionModel {

@JsonKey(includeToJson: false) String get id;@JsonKey(name: 's_id') int get sId; ExamSectionType get type; String get title; String get description; String get icon;
/// Create a copy of ExamSectionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamSectionModelCopyWith<ExamSectionModel> get copyWith => _$ExamSectionModelCopyWithImpl<ExamSectionModel>(this as ExamSectionModel, _$identity);

  /// Serializes this ExamSectionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamSectionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.sId, sId) || other.sId == sId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sId,type,title,description,icon);

@override
String toString() {
  return 'ExamSectionModel(id: $id, sId: $sId, type: $type, title: $title, description: $description, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $ExamSectionModelCopyWith<$Res>  {
  factory $ExamSectionModelCopyWith(ExamSectionModel value, $Res Function(ExamSectionModel) _then) = _$ExamSectionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 's_id') int sId, ExamSectionType type, String title, String description, String icon
});




}
/// @nodoc
class _$ExamSectionModelCopyWithImpl<$Res>
    implements $ExamSectionModelCopyWith<$Res> {
  _$ExamSectionModelCopyWithImpl(this._self, this._then);

  final ExamSectionModel _self;
  final $Res Function(ExamSectionModel) _then;

/// Create a copy of ExamSectionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sId = null,Object? type = null,Object? title = null,Object? description = null,Object? icon = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sId: null == sId ? _self.sId : sId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ExamSectionType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamSectionModel].
extension ExamSectionModelPatterns on ExamSectionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamSectionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamSectionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamSectionModel value)  $default,){
final _that = this;
switch (_that) {
case _ExamSectionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamSectionModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExamSectionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 's_id')  int sId,  ExamSectionType type,  String title,  String description,  String icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamSectionModel() when $default != null:
return $default(_that.id,_that.sId,_that.type,_that.title,_that.description,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 's_id')  int sId,  ExamSectionType type,  String title,  String description,  String icon)  $default,) {final _that = this;
switch (_that) {
case _ExamSectionModel():
return $default(_that.id,_that.sId,_that.type,_that.title,_that.description,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 's_id')  int sId,  ExamSectionType type,  String title,  String description,  String icon)?  $default,) {final _that = this;
switch (_that) {
case _ExamSectionModel() when $default != null:
return $default(_that.id,_that.sId,_that.type,_that.title,_that.description,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamSectionModel implements ExamSectionModel {
  const _ExamSectionModel({@JsonKey(includeToJson: false) required this.id, @JsonKey(name: 's_id') required this.sId, required this.type, required this.title, this.description = '', this.icon = ''});
  factory _ExamSectionModel.fromJson(Map<String, dynamic> json) => _$ExamSectionModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey(name: 's_id') final  int sId;
@override final  ExamSectionType type;
@override final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  String icon;

/// Create a copy of ExamSectionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamSectionModelCopyWith<_ExamSectionModel> get copyWith => __$ExamSectionModelCopyWithImpl<_ExamSectionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamSectionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamSectionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.sId, sId) || other.sId == sId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sId,type,title,description,icon);

@override
String toString() {
  return 'ExamSectionModel(id: $id, sId: $sId, type: $type, title: $title, description: $description, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$ExamSectionModelCopyWith<$Res> implements $ExamSectionModelCopyWith<$Res> {
  factory _$ExamSectionModelCopyWith(_ExamSectionModel value, $Res Function(_ExamSectionModel) _then) = __$ExamSectionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 's_id') int sId, ExamSectionType type, String title, String description, String icon
});




}
/// @nodoc
class __$ExamSectionModelCopyWithImpl<$Res>
    implements _$ExamSectionModelCopyWith<$Res> {
  __$ExamSectionModelCopyWithImpl(this._self, this._then);

  final _ExamSectionModel _self;
  final $Res Function(_ExamSectionModel) _then;

/// Create a copy of ExamSectionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sId = null,Object? type = null,Object? title = null,Object? description = null,Object? icon = null,}) {
  return _then(_ExamSectionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sId: null == sId ? _self.sId : sId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ExamSectionType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
