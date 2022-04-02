// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'follow.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Follow _$FollowFromJson(Map<String, dynamic> json) {
  return _Follow.fromJson(json);
}

/// @nodoc
class _$FollowTearOff {
  const _$FollowTearOff();

  _Follow call({required String id}) {
    return _Follow(
      id: id,
    );
  }

  Follow fromJson(Map<String, Object> json) {
    return Follow.fromJson(json);
  }
}

/// @nodoc
const $Follow = _$FollowTearOff();

/// @nodoc
mixin _$Follow {
  String get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FollowCopyWith<Follow> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowCopyWith<$Res> {
  factory $FollowCopyWith(Follow value, $Res Function(Follow) then) =
      _$FollowCopyWithImpl<$Res>;
  $Res call({String id});
}

/// @nodoc
class _$FollowCopyWithImpl<$Res> implements $FollowCopyWith<$Res> {
  _$FollowCopyWithImpl(this._value, this._then);

  final Follow _value;
  // ignore: unused_field
  final $Res Function(Follow) _then;

  @override
  $Res call({
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$FollowCopyWith<$Res> implements $FollowCopyWith<$Res> {
  factory _$FollowCopyWith(_Follow value, $Res Function(_Follow) then) =
      __$FollowCopyWithImpl<$Res>;
  @override
  $Res call({String id});
}

/// @nodoc
class __$FollowCopyWithImpl<$Res> extends _$FollowCopyWithImpl<$Res>
    implements _$FollowCopyWith<$Res> {
  __$FollowCopyWithImpl(_Follow _value, $Res Function(_Follow) _then)
      : super(_value, (v) => _then(v as _Follow));

  @override
  _Follow get _value => super._value as _Follow;

  @override
  $Res call({
    Object? id = freezed,
  }) {
    return _then(_Follow(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Follow implements _Follow {
  _$_Follow({required this.id});

  factory _$_Follow.fromJson(Map<String, dynamic> json) =>
      _$_$_FollowFromJson(json);

  @override
  final String id;

  @override
  String toString() {
    return 'Follow(id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Follow &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(id);

  @JsonKey(ignore: true)
  @override
  _$FollowCopyWith<_Follow> get copyWith =>
      __$FollowCopyWithImpl<_Follow>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_FollowToJson(this);
  }
}

abstract class _Follow implements Follow {
  factory _Follow({required String id}) = _$_Follow;

  factory _Follow.fromJson(Map<String, dynamic> json) = _$_Follow.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$FollowCopyWith<_Follow> get copyWith => throw _privateConstructorUsedError;
}
