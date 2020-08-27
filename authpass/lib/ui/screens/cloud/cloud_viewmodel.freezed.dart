// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'cloud_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$EmailViewModelTearOff {
  const _$EmailViewModelTearOff();

// ignore: unused_element
  _EmailViewModel call(
      {EmailMessage emailMessage,
      MimeMessage mimeMessage,
      Mailbox mailbox,
      KdbxEntry kdbxEntry}) {
    return _EmailViewModel(
      emailMessage: emailMessage,
      mimeMessage: mimeMessage,
      mailbox: mailbox,
      kdbxEntry: kdbxEntry,
    );
  }
}

// ignore: unused_element
const $EmailViewModel = _$EmailViewModelTearOff();

mixin _$EmailViewModel {
  EmailMessage get emailMessage;
  MimeMessage get mimeMessage;
  Mailbox get mailbox;
  KdbxEntry get kdbxEntry;

  $EmailViewModelCopyWith<EmailViewModel> get copyWith;
}

abstract class $EmailViewModelCopyWith<$Res> {
  factory $EmailViewModelCopyWith(
          EmailViewModel value, $Res Function(EmailViewModel) then) =
      _$EmailViewModelCopyWithImpl<$Res>;
  $Res call(
      {EmailMessage emailMessage,
      MimeMessage mimeMessage,
      Mailbox mailbox,
      KdbxEntry kdbxEntry});
}

class _$EmailViewModelCopyWithImpl<$Res>
    implements $EmailViewModelCopyWith<$Res> {
  _$EmailViewModelCopyWithImpl(this._value, this._then);

  final EmailViewModel _value;
  // ignore: unused_field
  final $Res Function(EmailViewModel) _then;

  @override
  $Res call({
    Object emailMessage = freezed,
    Object mimeMessage = freezed,
    Object mailbox = freezed,
    Object kdbxEntry = freezed,
  }) {
    return _then(_value.copyWith(
      emailMessage: emailMessage == freezed
          ? _value.emailMessage
          : emailMessage as EmailMessage,
      mimeMessage: mimeMessage == freezed
          ? _value.mimeMessage
          : mimeMessage as MimeMessage,
      mailbox: mailbox == freezed ? _value.mailbox : mailbox as Mailbox,
      kdbxEntry:
          kdbxEntry == freezed ? _value.kdbxEntry : kdbxEntry as KdbxEntry,
    ));
  }
}

abstract class _$EmailViewModelCopyWith<$Res>
    implements $EmailViewModelCopyWith<$Res> {
  factory _$EmailViewModelCopyWith(
          _EmailViewModel value, $Res Function(_EmailViewModel) then) =
      __$EmailViewModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {EmailMessage emailMessage,
      MimeMessage mimeMessage,
      Mailbox mailbox,
      KdbxEntry kdbxEntry});
}

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
    Object emailMessage = freezed,
    Object mimeMessage = freezed,
    Object mailbox = freezed,
    Object kdbxEntry = freezed,
  }) {
    return _then(_EmailViewModel(
      emailMessage: emailMessage == freezed
          ? _value.emailMessage
          : emailMessage as EmailMessage,
      mimeMessage: mimeMessage == freezed
          ? _value.mimeMessage
          : mimeMessage as MimeMessage,
      mailbox: mailbox == freezed ? _value.mailbox : mailbox as Mailbox,
      kdbxEntry:
          kdbxEntry == freezed ? _value.kdbxEntry : kdbxEntry as KdbxEntry,
    ));
  }
}

class _$_EmailViewModel implements _EmailViewModel {
  const _$_EmailViewModel(
      {this.emailMessage, this.mimeMessage, this.mailbox, this.kdbxEntry});

  @override
  final EmailMessage emailMessage;
  @override
  final MimeMessage mimeMessage;
  @override
  final Mailbox mailbox;
  @override
  final KdbxEntry kdbxEntry;

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

  @override
  _$EmailViewModelCopyWith<_EmailViewModel> get copyWith =>
      __$EmailViewModelCopyWithImpl<_EmailViewModel>(this, _$identity);
}

abstract class _EmailViewModel implements EmailViewModel {
  const factory _EmailViewModel(
      {EmailMessage emailMessage,
      MimeMessage mimeMessage,
      Mailbox mailbox,
      KdbxEntry kdbxEntry}) = _$_EmailViewModel;

  @override
  EmailMessage get emailMessage;
  @override
  MimeMessage get mimeMessage;
  @override
  Mailbox get mailbox;
  @override
  KdbxEntry get kdbxEntry;
  @override
  _$EmailViewModelCopyWith<_EmailViewModel> get copyWith;
}
