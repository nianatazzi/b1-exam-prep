// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'private_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubscriptionModel {

 SubscriptionPlan get plan;// null для плана free
 DateTime? get expiresAt;
/// Create a copy of SubscriptionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionModelCopyWith<SubscriptionModel> get copyWith => _$SubscriptionModelCopyWithImpl<SubscriptionModel>(this as SubscriptionModel, _$identity);

  /// Serializes this SubscriptionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionModel&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,plan,expiresAt);

@override
String toString() {
  return 'SubscriptionModel(plan: $plan, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $SubscriptionModelCopyWith<$Res>  {
  factory $SubscriptionModelCopyWith(SubscriptionModel value, $Res Function(SubscriptionModel) _then) = _$SubscriptionModelCopyWithImpl;
@useResult
$Res call({
 SubscriptionPlan plan, DateTime? expiresAt
});




}
/// @nodoc
class _$SubscriptionModelCopyWithImpl<$Res>
    implements $SubscriptionModelCopyWith<$Res> {
  _$SubscriptionModelCopyWithImpl(this._self, this._then);

  final SubscriptionModel _self;
  final $Res Function(SubscriptionModel) _then;

/// Create a copy of SubscriptionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plan = null,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as SubscriptionPlan,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionModel].
extension SubscriptionModelPatterns on SubscriptionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionModel value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionModel value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SubscriptionPlan plan,  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionModel() when $default != null:
return $default(_that.plan,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SubscriptionPlan plan,  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionModel():
return $default(_that.plan,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SubscriptionPlan plan,  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionModel() when $default != null:
return $default(_that.plan,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubscriptionModel implements SubscriptionModel {
  const _SubscriptionModel({required this.plan, this.expiresAt});
  factory _SubscriptionModel.fromJson(Map<String, dynamic> json) => _$SubscriptionModelFromJson(json);

@override final  SubscriptionPlan plan;
// null для плана free
@override final  DateTime? expiresAt;

/// Create a copy of SubscriptionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionModelCopyWith<_SubscriptionModel> get copyWith => __$SubscriptionModelCopyWithImpl<_SubscriptionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionModel&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,plan,expiresAt);

@override
String toString() {
  return 'SubscriptionModel(plan: $plan, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionModelCopyWith<$Res> implements $SubscriptionModelCopyWith<$Res> {
  factory _$SubscriptionModelCopyWith(_SubscriptionModel value, $Res Function(_SubscriptionModel) _then) = __$SubscriptionModelCopyWithImpl;
@override @useResult
$Res call({
 SubscriptionPlan plan, DateTime? expiresAt
});




}
/// @nodoc
class __$SubscriptionModelCopyWithImpl<$Res>
    implements _$SubscriptionModelCopyWith<$Res> {
  __$SubscriptionModelCopyWithImpl(this._self, this._then);

  final _SubscriptionModel _self;
  final $Res Function(_SubscriptionModel) _then;

/// Create a copy of SubscriptionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plan = null,Object? expiresAt = freezed,}) {
  return _then(_SubscriptionModel(
plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as SubscriptionPlan,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PrivateUserModel {

@JsonKey(includeToJson: false) String get id; String get deviceId; String get email; String get phone; SubscriptionModel get subscription; DateTime? get lastActiveDate; int get currentStreak; int get bestStreak;
/// Create a copy of PrivateUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivateUserModelCopyWith<PrivateUserModel> get copyWith => _$PrivateUserModelCopyWithImpl<PrivateUserModel>(this as PrivateUserModel, _$identity);

  /// Serializes this PrivateUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivateUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.subscription, subscription) || other.subscription == subscription)&&(identical(other.lastActiveDate, lastActiveDate) || other.lastActiveDate == lastActiveDate)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.bestStreak, bestStreak) || other.bestStreak == bestStreak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceId,email,phone,subscription,lastActiveDate,currentStreak,bestStreak);

@override
String toString() {
  return 'PrivateUserModel(id: $id, deviceId: $deviceId, email: $email, phone: $phone, subscription: $subscription, lastActiveDate: $lastActiveDate, currentStreak: $currentStreak, bestStreak: $bestStreak)';
}


}

/// @nodoc
abstract mixin class $PrivateUserModelCopyWith<$Res>  {
  factory $PrivateUserModelCopyWith(PrivateUserModel value, $Res Function(PrivateUserModel) _then) = _$PrivateUserModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String deviceId, String email, String phone, SubscriptionModel subscription, DateTime? lastActiveDate, int currentStreak, int bestStreak
});


$SubscriptionModelCopyWith<$Res> get subscription;

}
/// @nodoc
class _$PrivateUserModelCopyWithImpl<$Res>
    implements $PrivateUserModelCopyWith<$Res> {
  _$PrivateUserModelCopyWithImpl(this._self, this._then);

  final PrivateUserModel _self;
  final $Res Function(PrivateUserModel) _then;

/// Create a copy of PrivateUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deviceId = null,Object? email = null,Object? phone = null,Object? subscription = null,Object? lastActiveDate = freezed,Object? currentStreak = null,Object? bestStreak = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,subscription: null == subscription ? _self.subscription : subscription // ignore: cast_nullable_to_non_nullable
as SubscriptionModel,lastActiveDate: freezed == lastActiveDate ? _self.lastActiveDate : lastActiveDate // ignore: cast_nullable_to_non_nullable
as DateTime?,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,bestStreak: null == bestStreak ? _self.bestStreak : bestStreak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PrivateUserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubscriptionModelCopyWith<$Res> get subscription {
  
  return $SubscriptionModelCopyWith<$Res>(_self.subscription, (value) {
    return _then(_self.copyWith(subscription: value));
  });
}
}


/// Adds pattern-matching-related methods to [PrivateUserModel].
extension PrivateUserModelPatterns on PrivateUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivateUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivateUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivateUserModel value)  $default,){
final _that = this;
switch (_that) {
case _PrivateUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivateUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _PrivateUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String deviceId,  String email,  String phone,  SubscriptionModel subscription,  DateTime? lastActiveDate,  int currentStreak,  int bestStreak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivateUserModel() when $default != null:
return $default(_that.id,_that.deviceId,_that.email,_that.phone,_that.subscription,_that.lastActiveDate,_that.currentStreak,_that.bestStreak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String deviceId,  String email,  String phone,  SubscriptionModel subscription,  DateTime? lastActiveDate,  int currentStreak,  int bestStreak)  $default,) {final _that = this;
switch (_that) {
case _PrivateUserModel():
return $default(_that.id,_that.deviceId,_that.email,_that.phone,_that.subscription,_that.lastActiveDate,_that.currentStreak,_that.bestStreak);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String deviceId,  String email,  String phone,  SubscriptionModel subscription,  DateTime? lastActiveDate,  int currentStreak,  int bestStreak)?  $default,) {final _that = this;
switch (_that) {
case _PrivateUserModel() when $default != null:
return $default(_that.id,_that.deviceId,_that.email,_that.phone,_that.subscription,_that.lastActiveDate,_that.currentStreak,_that.bestStreak);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrivateUserModel implements PrivateUserModel {
  const _PrivateUserModel({@JsonKey(includeToJson: false) required this.id, required this.deviceId, required this.email, required this.phone, required this.subscription, this.lastActiveDate, this.currentStreak = 0, this.bestStreak = 0});
  factory _PrivateUserModel.fromJson(Map<String, dynamic> json) => _$PrivateUserModelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String deviceId;
@override final  String email;
@override final  String phone;
@override final  SubscriptionModel subscription;
@override final  DateTime? lastActiveDate;
@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int bestStreak;

/// Create a copy of PrivateUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivateUserModelCopyWith<_PrivateUserModel> get copyWith => __$PrivateUserModelCopyWithImpl<_PrivateUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrivateUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivateUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.subscription, subscription) || other.subscription == subscription)&&(identical(other.lastActiveDate, lastActiveDate) || other.lastActiveDate == lastActiveDate)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.bestStreak, bestStreak) || other.bestStreak == bestStreak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceId,email,phone,subscription,lastActiveDate,currentStreak,bestStreak);

@override
String toString() {
  return 'PrivateUserModel(id: $id, deviceId: $deviceId, email: $email, phone: $phone, subscription: $subscription, lastActiveDate: $lastActiveDate, currentStreak: $currentStreak, bestStreak: $bestStreak)';
}


}

/// @nodoc
abstract mixin class _$PrivateUserModelCopyWith<$Res> implements $PrivateUserModelCopyWith<$Res> {
  factory _$PrivateUserModelCopyWith(_PrivateUserModel value, $Res Function(_PrivateUserModel) _then) = __$PrivateUserModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String deviceId, String email, String phone, SubscriptionModel subscription, DateTime? lastActiveDate, int currentStreak, int bestStreak
});


@override $SubscriptionModelCopyWith<$Res> get subscription;

}
/// @nodoc
class __$PrivateUserModelCopyWithImpl<$Res>
    implements _$PrivateUserModelCopyWith<$Res> {
  __$PrivateUserModelCopyWithImpl(this._self, this._then);

  final _PrivateUserModel _self;
  final $Res Function(_PrivateUserModel) _then;

/// Create a copy of PrivateUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deviceId = null,Object? email = null,Object? phone = null,Object? subscription = null,Object? lastActiveDate = freezed,Object? currentStreak = null,Object? bestStreak = null,}) {
  return _then(_PrivateUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,subscription: null == subscription ? _self.subscription : subscription // ignore: cast_nullable_to_non_nullable
as SubscriptionModel,lastActiveDate: freezed == lastActiveDate ? _self.lastActiveDate : lastActiveDate // ignore: cast_nullable_to_non_nullable
as DateTime?,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,bestStreak: null == bestStreak ? _self.bestStreak : bestStreak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PrivateUserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubscriptionModelCopyWith<$Res> get subscription {
  
  return $SubscriptionModelCopyWith<$Res>(_self.subscription, (value) {
    return _then(_self.copyWith(subscription: value));
  });
}
}

// dart format on
