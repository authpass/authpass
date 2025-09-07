// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cloud_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EmailViewModel {

 EmailMessage get emailMessage; MimeMessage? get mimeMessage; Mailbox? get mailbox; KdbxEntry? get kdbxEntry;
/// Create a copy of EmailViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmailViewModelCopyWith<EmailViewModel> get copyWith => _$EmailViewModelCopyWithImpl<EmailViewModel>(this as EmailViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailViewModel&&(identical(other.emailMessage, emailMessage) || other.emailMessage == emailMessage)&&(identical(other.mimeMessage, mimeMessage) || other.mimeMessage == mimeMessage)&&(identical(other.mailbox, mailbox) || other.mailbox == mailbox)&&(identical(other.kdbxEntry, kdbxEntry) || other.kdbxEntry == kdbxEntry));
}


@override
int get hashCode => Object.hash(runtimeType,emailMessage,mimeMessage,mailbox,kdbxEntry);

@override
String toString() {
  return 'EmailViewModel(emailMessage: $emailMessage, mimeMessage: $mimeMessage, mailbox: $mailbox, kdbxEntry: $kdbxEntry)';
}


}

/// @nodoc
abstract mixin class $EmailViewModelCopyWith<$Res>  {
  factory $EmailViewModelCopyWith(EmailViewModel value, $Res Function(EmailViewModel) _then) = _$EmailViewModelCopyWithImpl;
@useResult
$Res call({
 EmailMessage emailMessage, MimeMessage? mimeMessage, Mailbox? mailbox, KdbxEntry? kdbxEntry
});




}
/// @nodoc
class _$EmailViewModelCopyWithImpl<$Res>
    implements $EmailViewModelCopyWith<$Res> {
  _$EmailViewModelCopyWithImpl(this._self, this._then);

  final EmailViewModel _self;
  final $Res Function(EmailViewModel) _then;

/// Create a copy of EmailViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emailMessage = null,Object? mimeMessage = freezed,Object? mailbox = freezed,Object? kdbxEntry = freezed,}) {
  return _then(_self.copyWith(
emailMessage: null == emailMessage ? _self.emailMessage : emailMessage // ignore: cast_nullable_to_non_nullable
as EmailMessage,mimeMessage: freezed == mimeMessage ? _self.mimeMessage : mimeMessage // ignore: cast_nullable_to_non_nullable
as MimeMessage?,mailbox: freezed == mailbox ? _self.mailbox : mailbox // ignore: cast_nullable_to_non_nullable
as Mailbox?,kdbxEntry: freezed == kdbxEntry ? _self.kdbxEntry : kdbxEntry // ignore: cast_nullable_to_non_nullable
as KdbxEntry?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmailViewModel].
extension EmailViewModelPatterns on EmailViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmailViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmailViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmailViewModel value)  $default,){
final _that = this;
switch (_that) {
case _EmailViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmailViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmailViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EmailMessage emailMessage,  MimeMessage? mimeMessage,  Mailbox? mailbox,  KdbxEntry? kdbxEntry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmailViewModel() when $default != null:
return $default(_that.emailMessage,_that.mimeMessage,_that.mailbox,_that.kdbxEntry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EmailMessage emailMessage,  MimeMessage? mimeMessage,  Mailbox? mailbox,  KdbxEntry? kdbxEntry)  $default,) {final _that = this;
switch (_that) {
case _EmailViewModel():
return $default(_that.emailMessage,_that.mimeMessage,_that.mailbox,_that.kdbxEntry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EmailMessage emailMessage,  MimeMessage? mimeMessage,  Mailbox? mailbox,  KdbxEntry? kdbxEntry)?  $default,) {final _that = this;
switch (_that) {
case _EmailViewModel() when $default != null:
return $default(_that.emailMessage,_that.mimeMessage,_that.mailbox,_that.kdbxEntry);case _:
  return null;

}
}

}

/// @nodoc


class _EmailViewModel implements EmailViewModel {
  const _EmailViewModel({required this.emailMessage, this.mimeMessage, this.mailbox, this.kdbxEntry});
  

@override final  EmailMessage emailMessage;
@override final  MimeMessage? mimeMessage;
@override final  Mailbox? mailbox;
@override final  KdbxEntry? kdbxEntry;

/// Create a copy of EmailViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmailViewModelCopyWith<_EmailViewModel> get copyWith => __$EmailViewModelCopyWithImpl<_EmailViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailViewModel&&(identical(other.emailMessage, emailMessage) || other.emailMessage == emailMessage)&&(identical(other.mimeMessage, mimeMessage) || other.mimeMessage == mimeMessage)&&(identical(other.mailbox, mailbox) || other.mailbox == mailbox)&&(identical(other.kdbxEntry, kdbxEntry) || other.kdbxEntry == kdbxEntry));
}


@override
int get hashCode => Object.hash(runtimeType,emailMessage,mimeMessage,mailbox,kdbxEntry);

@override
String toString() {
  return 'EmailViewModel(emailMessage: $emailMessage, mimeMessage: $mimeMessage, mailbox: $mailbox, kdbxEntry: $kdbxEntry)';
}


}

/// @nodoc
abstract mixin class _$EmailViewModelCopyWith<$Res> implements $EmailViewModelCopyWith<$Res> {
  factory _$EmailViewModelCopyWith(_EmailViewModel value, $Res Function(_EmailViewModel) _then) = __$EmailViewModelCopyWithImpl;
@override @useResult
$Res call({
 EmailMessage emailMessage, MimeMessage? mimeMessage, Mailbox? mailbox, KdbxEntry? kdbxEntry
});




}
/// @nodoc
class __$EmailViewModelCopyWithImpl<$Res>
    implements _$EmailViewModelCopyWith<$Res> {
  __$EmailViewModelCopyWithImpl(this._self, this._then);

  final _EmailViewModel _self;
  final $Res Function(_EmailViewModel) _then;

/// Create a copy of EmailViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emailMessage = null,Object? mimeMessage = freezed,Object? mailbox = freezed,Object? kdbxEntry = freezed,}) {
  return _then(_EmailViewModel(
emailMessage: null == emailMessage ? _self.emailMessage : emailMessage // ignore: cast_nullable_to_non_nullable
as EmailMessage,mimeMessage: freezed == mimeMessage ? _self.mimeMessage : mimeMessage // ignore: cast_nullable_to_non_nullable
as MimeMessage?,mailbox: freezed == mailbox ? _self.mailbox : mailbox // ignore: cast_nullable_to_non_nullable
as Mailbox?,kdbxEntry: freezed == kdbxEntry ? _self.kdbxEntry : kdbxEntry // ignore: cast_nullable_to_non_nullable
as KdbxEntry?,
  ));
}


}

// dart format on
