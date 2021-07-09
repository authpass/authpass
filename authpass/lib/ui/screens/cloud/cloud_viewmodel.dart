import 'package:authpass_cloud_shared/authpass_cloud_shared.dart';
import 'package:built_value/built_value.dart';
import 'package:enough_mail/enough_mail.dart' show MimeMessage;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kdbx/kdbx.dart';

part 'cloud_viewmodel.freezed.dart';

@freezed
class EmailViewModel with _$EmailViewModel {
  const factory EmailViewModel({
    @nullable EmailMessage? emailMessage,
    @nullable MimeMessage? mimeMessage,
    @nullable Mailbox? mailbox,
    @nullable KdbxEntry? kdbxEntry,
  }) = _EmailViewModel;
}
