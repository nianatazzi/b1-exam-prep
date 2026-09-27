// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonModel {

@JsonKey(includeToJson: false) String get id;@JsonKey(name: 'lexical_topic_id') String get lexicalTopicId;@JsonKey(name: 'grammar_topic_id') String get grammarTopicId;@JsonKey(name: 'image_task') ImageTaskModel get imageTask;@JsonKey(name: 'monologue_task') FreePracticeTaskModel get monologueTask;@JsonKey(name: 'dialogue_task') DialogueScenarioModel get dialogueTask;@JsonKey(name: 'duration_seconds') int? get durationSeconds;
/// Create a copy of LessonModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonModelCopyWith<LessonModel> get copyWith => _$LessonModelCopyWithImpl<LessonModel>(this as LessonModel, _$identity);

  /// Serializes this LessonModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonModel&&(identical(other.id, id) || other.id == id)&&(identical(other.lexicalTopicId, lexicalTopicId) || other.lexicalTopicId == lexicalTopicId)&&(identical(other.grammarTopicId, grammarTopicId) || other.grammarTopicId == grammarTopicId)&&(identical(other.imageTask, imageTask) || other.imageTask == imageTask)&&(identical(other.monologueTask, monologueTask) || other.monologueTask == monologueTask)&&(identical(other.dialogueTask, dialogueTask) || other.dialogueTask == dialogueTask)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lexicalTopicId,grammarTopicId,imageTask,monologueTask,dialogueTask,durationSeconds);

@override
String toString() {
  return 'LessonModel(id: $id, lexicalTopicId: $lexicalTopicId, grammarTopicId: $grammarTopicId, imageTask: $imageTask, monologueTask: $monologueTask, dialogueTask: $dialogueTask, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class $LessonModelCopyWith<$Res>  {
  factory $LessonModelCopyWith(LessonModel value, $Res Function(LessonModel) _then) = _$LessonModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'lexical_topic_id') String lexicalTopicId,@JsonKey(name: 'grammar_topic_id') String grammarTopicId,@JsonKey(name: 'image_task') ImageTaskModel imageTask,@JsonKey(name: 'monologue_task') FreePracticeTaskModel monologueTask,@JsonKey(name: 'dialogue_task') DialogueScenarioModel dialogueTask,@JsonKey(name: 'duration_seconds') int? durationSeconds
});


$ImageTaskModelCopyWith<$Res> get imageTask;$FreePracticeTaskModelCopyWith<$Res> get monologueTask;$DialogueScenarioModelCopyWith<$Res> get dialogueTask;

}
/// @nodoc
class _$LessonModelCopyWithImpl<$Res>
    implements $LessonModelCopyWith<$Res> {
  _$LessonModelCopyWithImpl(this._self, this._then);

  final LessonModel _self;
  final $Res Function(LessonModel) _then;

/// Create a copy of LessonModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lexicalTopicId = null,Object? grammarTopicId = null,Object? imageTask = null,Object? monologueTask = null,Object? dialogueTask = null,Object? durationSeconds = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lexicalTopicId: null == lexicalTopicId ? _self.lexicalTopicId : lexicalTopicId // ignore: cast_nullable_to_non_nullable
as String,grammarTopicId: null == grammarTopicId ? _self.grammarTopicId : grammarTopicId // ignore: cast_nullable_to_non_nullable
as String,imageTask: null == imageTask ? _self.imageTask : imageTask // ignore: cast_nullable_to_non_nullable
as ImageTaskModel,monologueTask: null == monologueTask ? _self.monologueTask : monologueTask // ignore: cast_nullable_to_non_nullable
as FreePracticeTaskModel,dialogueTask: null == dialogueTask ? _self.dialogueTask : dialogueTask // ignore: cast_nullable_to_non_nullable
as DialogueScenarioModel,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of LessonModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageTaskModelCopyWith<$Res> get imageTask {
  
  return $ImageTaskModelCopyWith<$Res>(_self.imageTask, (value) {
    return _then(_self.copyWith(imageTask: value));
  });
}/// Create a copy of LessonModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreePracticeTaskModelCopyWith<$Res> get monologueTask {
  
  return $FreePracticeTaskModelCopyWith<$Res>(_self.monologueTask, (value) {
    return _then(_self.copyWith(monologueTask: value));
  });
}/// Create a copy of LessonModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DialogueScenarioModelCopyWith<$Res> get dialogueTask {
  
  return $DialogueScenarioModelCopyWith<$Res>(_self.dialogueTask, (value) {
    return _then(_self.copyWith(dialogueTask: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonModel].
extension LessonModelPatterns on LessonModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonModel value)  $default,){
final _that = this;
switch (_that) {
case _LessonModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonModel value)?  $default,){
final _that = this;
switch (_that) {
case _LessonModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'lexical_topic_id')  String lexicalTopicId, @JsonKey(name: 'grammar_topic_id')  String grammarTopicId, @JsonKey(name: 'image_task')  ImageTaskModel imageTask, @JsonKey(name: 'monologue_task')  FreePracticeTaskModel monologueTask, @JsonKey(name: 'dialogue_task')  DialogueScenarioModel dialogueTask, @JsonKey(name: 'duration_seconds')  int? durationSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonModel() when $default != null:
return $default(_that.id,_that.lexicalTopicId,_that.grammarTopicId,_that.imageTask,_that.monologueTask,_that.dialogueTask,_that.durationSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'lexical_topic_id')  String lexicalTopicId, @JsonKey(name: 'grammar_topic_id')  String grammarTopicId, @JsonKey(name: 'image_task')  ImageTaskModel imageTask, @JsonKey(name: 'monologue_task')  FreePracticeTaskModel monologueTask, @JsonKey(name: 'dialogue_task')  DialogueScenarioModel dialogueTask, @JsonKey(name: 'duration_seconds')  int? durationSeconds)  $default,) {final _that = this;
switch (_that) {
case _LessonModel():
return $default(_that.id,_that.lexicalTopicId,_that.grammarTopicId,_that.imageTask,_that.monologueTask,_that.dialogueTask,_that.durationSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id, @JsonKey(name: 'lexical_topic_id')  String lexicalTopicId, @JsonKey(name: 'grammar_topic_id')  String grammarTopicId, @JsonKey(name: 'image_task')  ImageTaskModel imageTask, @JsonKey(name: 'monologue_task')  FreePracticeTaskModel monologueTask, @JsonKey(name: 'dialogue_task')  DialogueScenarioModel dialogueTask, @JsonKey(name: 'duration_seconds')  int? durationSeconds)?  $default,) {final _that = this;
switch (_that) {
case _LessonModel() when $default != null:
return $default(_that.id,_that.lexicalTopicId,_that.grammarTopicId,_that.imageTask,_that.monologueTask,_that.dialogueTask,_that.durationSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonModel implements LessonModel {
  const _LessonModel({@JsonKey(includeToJson: false) required this.id, @JsonKey(name: 'lexical_topic_id') required this.lexicalTopicId, @JsonKey(name: 'grammar_topic_id') required this.grammarTopicId, @JsonKey(name: 'image_task') required this.imageTask, @JsonKey(name: 'monologue_task') required this.monologueTask, @JsonKey(name: 'dialogue_task') required this.dialogueTask, @JsonKey(name: 'duration_seconds') this.durationSeconds});
  factory _LessonModel.fromJson(Map<String, dynamic> json) => _$LessonModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey(name: 'lexical_topic_id') final  String lexicalTopicId;
@override@JsonKey(name: 'grammar_topic_id') final  String grammarTopicId;
@override@JsonKey(name: 'image_task') final  ImageTaskModel imageTask;
@override@JsonKey(name: 'monologue_task') final  FreePracticeTaskModel monologueTask;
@override@JsonKey(name: 'dialogue_task') final  DialogueScenarioModel dialogueTask;
@override@JsonKey(name: 'duration_seconds') final  int? durationSeconds;

/// Create a copy of LessonModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonModelCopyWith<_LessonModel> get copyWith => __$LessonModelCopyWithImpl<_LessonModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonModel&&(identical(other.id, id) || other.id == id)&&(identical(other.lexicalTopicId, lexicalTopicId) || other.lexicalTopicId == lexicalTopicId)&&(identical(other.grammarTopicId, grammarTopicId) || other.grammarTopicId == grammarTopicId)&&(identical(other.imageTask, imageTask) || other.imageTask == imageTask)&&(identical(other.monologueTask, monologueTask) || other.monologueTask == monologueTask)&&(identical(other.dialogueTask, dialogueTask) || other.dialogueTask == dialogueTask)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lexicalTopicId,grammarTopicId,imageTask,monologueTask,dialogueTask,durationSeconds);

@override
String toString() {
  return 'LessonModel(id: $id, lexicalTopicId: $lexicalTopicId, grammarTopicId: $grammarTopicId, imageTask: $imageTask, monologueTask: $monologueTask, dialogueTask: $dialogueTask, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class _$LessonModelCopyWith<$Res> implements $LessonModelCopyWith<$Res> {
  factory _$LessonModelCopyWith(_LessonModel value, $Res Function(_LessonModel) _then) = __$LessonModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id,@JsonKey(name: 'lexical_topic_id') String lexicalTopicId,@JsonKey(name: 'grammar_topic_id') String grammarTopicId,@JsonKey(name: 'image_task') ImageTaskModel imageTask,@JsonKey(name: 'monologue_task') FreePracticeTaskModel monologueTask,@JsonKey(name: 'dialogue_task') DialogueScenarioModel dialogueTask,@JsonKey(name: 'duration_seconds') int? durationSeconds
});


@override $ImageTaskModelCopyWith<$Res> get imageTask;@override $FreePracticeTaskModelCopyWith<$Res> get monologueTask;@override $DialogueScenarioModelCopyWith<$Res> get dialogueTask;

}
/// @nodoc
class __$LessonModelCopyWithImpl<$Res>
    implements _$LessonModelCopyWith<$Res> {
  __$LessonModelCopyWithImpl(this._self, this._then);

  final _LessonModel _self;
  final $Res Function(_LessonModel) _then;

/// Create a copy of LessonModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lexicalTopicId = null,Object? grammarTopicId = null,Object? imageTask = null,Object? monologueTask = null,Object? dialogueTask = null,Object? durationSeconds = freezed,}) {
  return _then(_LessonModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lexicalTopicId: null == lexicalTopicId ? _self.lexicalTopicId : lexicalTopicId // ignore: cast_nullable_to_non_nullable
as String,grammarTopicId: null == grammarTopicId ? _self.grammarTopicId : grammarTopicId // ignore: cast_nullable_to_non_nullable
as String,imageTask: null == imageTask ? _self.imageTask : imageTask // ignore: cast_nullable_to_non_nullable
as ImageTaskModel,monologueTask: null == monologueTask ? _self.monologueTask : monologueTask // ignore: cast_nullable_to_non_nullable
as FreePracticeTaskModel,dialogueTask: null == dialogueTask ? _self.dialogueTask : dialogueTask // ignore: cast_nullable_to_non_nullable
as DialogueScenarioModel,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of LessonModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageTaskModelCopyWith<$Res> get imageTask {
  
  return $ImageTaskModelCopyWith<$Res>(_self.imageTask, (value) {
    return _then(_self.copyWith(imageTask: value));
  });
}/// Create a copy of LessonModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreePracticeTaskModelCopyWith<$Res> get monologueTask {
  
  return $FreePracticeTaskModelCopyWith<$Res>(_self.monologueTask, (value) {
    return _then(_self.copyWith(monologueTask: value));
  });
}/// Create a copy of LessonModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DialogueScenarioModelCopyWith<$Res> get dialogueTask {
  
  return $DialogueScenarioModelCopyWith<$Res>(_self.dialogueTask, (value) {
    return _then(_self.copyWith(dialogueTask: value));
  });
}
}

// dart format on
