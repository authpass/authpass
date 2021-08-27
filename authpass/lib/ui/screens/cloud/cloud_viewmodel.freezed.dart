// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'cloud_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$EmailViewModelTearOff {
  const _$EmailViewModelTearOff();

  _EmailViewModel call(
      {required EmailMessage emailMessage,
      MimeMessage? mimeMessage,
      Mailbox? mailbox,
      KdbxEntry? kdbxEntry}) {
    return _EmailViewModel(
      emailMessage: emailMessage,
      mimeMessage: mimeMessage,
      mailbox: mailbox,
      kdbxEntry: kdbxEntry,
    );
  }
}

/// @nodoc
const $EmailViewModel = _$EmailViewModelTearOff();

/// @nodoc
mixin _$EmailViewModel {
  EmailMessage get emailMessage => throw _privateConstructorUsedError;
  MimeMessage? get mimeMessage => throw _privateConstructorUsedError;
  Mailbox? get mailbox => throw _privateConstructorUsedError;
  KdbxEntry? get kdbxEntry => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EmailViewModelCopyWith<EmailViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailViewModelCopyWith<$Res> {
  factory $EmailViewModelCopyWith(
          EmailViewModel value, $Res Function(EmailViewModel) then) =
      _$EmailViewModelCopyWithImpl<$Res>;
  $Res call(
      {EmailMessage emailMessage,
      MimeMessage? mimeMessage,
      Mailbox? mailbox,
      KdbxEntry? kdbxEntry});
}

/// @nodoc
class _$EmailViewModelCopyWithImpl<$Res>
    implements $EmailViewModelCopyWith<$Res> {
  _$EmailViewModelCopyWithImpl(this._value, this._then);

  final EmailViewModel _value;
  // ignore: unused_field
  final $Res Function(EmailViewModel) _then;

  @override
  $Res call({
    Object? emailMessage = freezed,
    Object? mimeMessage = freezed,
    Object? mailbox = freezed,
    Object? kdbxEntry = freezed,
  }) {
    return _then(_value.copyWith(
      emailMessage: emailMessage == freezed
          ? _value.emailMessage
          : emailMessage // ignore: cast_nullable_to_non_nullable
              as EmailMessage,
      mimeMessage: mimeMessage == freezed
          ? _value.mimeMessage
          : mimeMessage // ignore: cast_nullable_to_non_nullable
              as MimeMessage?,
      mailbox: mailbox == freezed
          ? _value.mailbox
          : mailbox // ignore: cast_nullable_to_non_nullable
              as Mailbox?,
      kdbxEntry: kdbxEntry == freezed
          ? _value.kdbxEntry
          : kdbxEntry // ignore: cast_nullable_to_non_nullable
              as KdbxEntry?,
    ));
  }
}

/// @nodoc
abstract class _$EmailViewModelCopyWith<$Res>
    implements $EmailViewModelCopyWith<$Res> {
  factory _$EmailViewModelCopyWith(
          _EmailViewModel value, $Res Function(_EmailViewModel) then) =
      __$EmailViewModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {EmailMessage emailMessage,
      MimeMessage? mimeMessage,
      Mailbox? mailbox,
      KdbxEntry? kdbxEntry});
}

/// @nodoc
class __$EmailViewModelCopyWithImpl<$Res>
    extends _$EmailViewModelCopyWithImpl<$Res>
    implements _$EmailViewModelCopyWith<$Res> {
  __$EmailViewModelCopyWithImpl(
      _EmailViewModel _value, $Res Function(_EmailViewModel) _then)
      : super(_value, (v) => _then(v as _EmailViewModel));

  @override
  _EmailViewModel get _value => super._value as _EmailViewModel;

  @override
  $Res call({
    Object? emailMessage = freezed,
    Object? mimeMessage = freezed,
    Object? mailbox = freezed,
    Object? kdbxEntry = freezed,
  }) {
    return _then(_EmailViewModel(
      emailMessage: emailMessage == freezed
          ? _value.emailMessage
          : emailMessage // ignore: cast_nullable_to_non_nullable
              as EmailMessage,
      mimeMessage: mimeMessage == freezed
          ? _value.mimeMessage
          : mimeMessage // ignore: cast_nullable_to_non_nullable
              as MimeMessage?,
      mailbox: mailbox == freezed
          ? _value.mailbox
          : mailbox // ignore: cast_nullable_to_non_nullable
              as Mailbox?,
      kdbxEntry: kdbxEntry == freezed
          ? _value.kdbxEntry
          : kdbxEntry // ignore: cast_nullable_to_non_nullable
              as KdbxEntry?,
    ));
  }
}

/// @nodoc

class _$_EmailViewModel implements _EmailViewModel {
  const _$_EmailViewModel(
      {required this.emailMessage,
      this.mimeMessage,
      this.mailbox,
      this.kdbxEntry});

  @override
  final EmailMessage emailMessage;
  @override
  final MimeMessage? mimeMessage;
  @override
  final Mailbox? mailbox;
  @override
  final KdbxEntry? kdbxEntry;

  @override
  String toString() {
    return 'EmailViewModel(emailMessage: $emailMessage, mimeMessage: $mimeMessage, mailbox: $mailbox, kdbxEntry: $kdbxEntry)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _EmailViewModel &&
            (identical(other.emailMessage, emailMessage) ||
                const DeepCollectionEquality()
                    .equals(other.emailMessage, emailMessage)) &&
            (identical(other.mimeMessage, mimeMessage) ||
                const DeepCollectionEquality()
                    .equals(other.mimeMessage, mimeMessage)) &&
            (identical(other.mailbox, mailbox) ||
                const DeepCollectionEquality()
                    .equals(other.mailbox, mailbox)) &&
            (identical(other.kdbxEntry, kdbxEntry) ||
                const DeepCollectionEquality()
                    .equals(other.kdbxEntry, kdbxEntry)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(emailMessage) ^
      const DeepCollectionEquality().hash(mimeMessage) ^
      const DeepCollectionEquality().hash(mailbox) ^
      const DeepCollectionEquality().hash(kdbxEntry);

  @JsonKey(ignore: true)
  @override
  _$EmailViewModelCopyWith<_EmailViewModel> get copyWith =>
      __$EmailViewModelCopyWithImpl<_EmailViewModel>(this, _$identity);
}

abstract class _EmailViewModel implements EmailViewModel {
  const factory _EmailViewModel(
      {required EmailMessage emailMessage,
      MimeMessage? mimeMessage,
      Mailbox? mailbox,
      KdbxEntry? kdbxEntry}) = _$_EmailViewModel;

  @override
  EmailMessage get emailMessage => throw _privateConstructorUsedError;
  @override
  MimeMessage? get mimeMessage => throw _privateConstructorUsedError;
  @override
  Mailbox? get mailbox => throw _privateConstructorUsedError;
  @override
  KdbxEntry? get kdbxEntry => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$EmailViewModelCopyWith<_EmailViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}
