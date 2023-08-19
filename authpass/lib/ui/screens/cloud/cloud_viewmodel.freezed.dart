// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cloud_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
      _$EmailViewModelCopyWithImpl<$Res, EmailViewModel>;
  @useResult
  $Res call(
      {EmailMessage emailMessage,
      MimeMessage? mimeMessage,
      Mailbox? mailbox,
      KdbxEntry? kdbxEntry});
}

/// @nodoc
class _$EmailViewModelCopyWithImpl<$Res, $Val extends EmailViewModel>
    implements $EmailViewModelCopyWith<$Res> {
  _$EmailViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailMessage = null,
    Object? mimeMessage = freezed,
    Object? mailbox = freezed,
    Object? kdbxEntry = freezed,
  }) {
    return _then(_value.copyWith(
      emailMessage: null == emailMessage
          ? _value.emailMessage
          : emailMessage // ignore: cast_nullable_to_non_nullable
              as EmailMessage,
      mimeMessage: freezed == mimeMessage
          ? _value.mimeMessage
          : mimeMessage // ignore: cast_nullable_to_non_nullable
              as MimeMessage?,
      mailbox: freezed == mailbox
          ? _value.mailbox
          : mailbox // ignore: cast_nullable_to_non_nullable
              as Mailbox?,
      kdbxEntry: freezed == kdbxEntry
          ? _value.kdbxEntry
          : kdbxEntry // ignore: cast_nullable_to_non_nullable
              as KdbxEntry?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_EmailViewModelCopyWith<$Res>
    implements $EmailViewModelCopyWith<$Res> {
  factory _$$_EmailViewModelCopyWith(
          _$_EmailViewModel value, $Res Function(_$_EmailViewModel) then) =
      __$$_EmailViewModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {EmailMessage emailMessage,
      MimeMessage? mimeMessage,
      Mailbox? mailbox,
      KdbxEntry? kdbxEntry});
}

/// @nodoc
class __$$_EmailViewModelCopyWithImpl<$Res>
    extends _$EmailViewModelCopyWithImpl<$Res, _$_EmailViewModel>
    implements _$$_EmailViewModelCopyWith<$Res> {
  __$$_EmailViewModelCopyWithImpl(
      _$_EmailViewModel _value, $Res Function(_$_EmailViewModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailMessage = null,
    Object? mimeMessage = freezed,
    Object? mailbox = freezed,
    Object? kdbxEntry = freezed,
  }) {
    return _then(_$_EmailViewModel(
      emailMessage: null == emailMessage
          ? _value.emailMessage
          : emailMessage // ignore: cast_nullable_to_non_nullable
              as EmailMessage,
      mimeMessage: freezed == mimeMessage
          ? _value.mimeMessage
          : mimeMessage // ignore: cast_nullable_to_non_nullable
              as MimeMessage?,
      mailbox: freezed == mailbox
          ? _value.mailbox
          : mailbox // ignore: cast_nullable_to_non_nullable
              as Mailbox?,
      kdbxEntry: freezed == kdbxEntry
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
        (other.runtimeType == runtimeType &&
            other is _$_EmailViewModel &&
            (identical(other.emailMessage, emailMessage) ||
                other.emailMessage == emailMessage) &&
            (identical(other.mimeMessage, mimeMessage) ||
                other.mimeMessage == mimeMessage) &&
            (identical(other.mailbox, mailbox) || other.mailbox == mailbox) &&
            (identical(other.kdbxEntry, kdbxEntry) ||
                other.kdbxEntry == kdbxEntry));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, emailMessage, mimeMessage, mailbox, kdbxEntry);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EmailViewModelCopyWith<_$_EmailViewModel> get copyWith =>
      __$$_EmailViewModelCopyWithImpl<_$_EmailViewModel>(this, _$identity);
}

abstract class _EmailViewModel implements EmailViewModel {
  const factory _EmailViewModel(
      {required final EmailMessage emailMessage,
      final MimeMessage? mimeMessage,
      final Mailbox? mailbox,
      final KdbxEntry? kdbxEntry}) = _$_EmailViewModel;

  @override
  EmailMessage get emailMessage;
  @override
  MimeMessage? get mimeMessage;
  @override
  Mailbox? get mailbox;
  @override
  KdbxEntry? get kdbxEntry;
  @override
  @JsonKey(ignore: true)
  _$$_EmailViewModelCopyWith<_$_EmailViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}
