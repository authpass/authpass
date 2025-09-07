// ignore_for_file: omit_local_variable_types,unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get fieldUserName => '用户';

  @override
  String get fieldPassword => '密码';

  @override
  String get fieldWebsite => '目标网站';

  @override
  String get fieldTitle => '标题';

  @override
  String get fieldTotp => '基于时间的身份验证 (TOTP)';

  @override
  String get english => 'English';

  @override
  String get german => '德语';

  @override
  String get russian => '俄语';

  @override
  String get ukrainian => '乌克兰语';

  @override
  String get lithuanian => '立陶宛语';

  @override
  String get french => '法语';

  @override
  String get spanish => '西班牙语';

  @override
  String get indonesian => '印度尼西亚语';

  @override
  String get turkish => '土耳其语';

  @override
  String get hebrew => '希伯来语';

  @override
  String get italian => '意大利语';

  @override
  String get chineseSimplified => '简体中文';

  @override
  String get chineseTraditional => '繁体中文';

  @override
  String get portugueseBrazilian => '葡萄牙语（巴西）';

  @override
  String get slovak => '斯洛伐克语';

  @override
  String get dutch => '荷兰语';

  @override
  String get selectItem => '选择…';

  @override
  String get selectKeepassFile => 'AuthPass - 打开密码库';

  @override
  String get selectKeepassFileLabel => '请打开一个数据库，后缀名为.kdbx';

  @override
  String get createNewFile => '新建一个';

  @override
  String get openLocalFile => '本地\n文件';

  @override
  String get openFile => '打开文件';

  @override
  String get loadFromDropdownMenu => '更多…';

  @override
  String get quickUnlockingFiles => '正在解锁文件…';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return '正在准备 $fileName …\n已完成($current / $totalCount)';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return '从 $cloudStorageName 导入';
  }

  @override
  String get loadFromRemoteUrl => '从链接打开KDBX文件';

  @override
  String get createNewKeepass => '首次使用？\n创建新的密码库';

  @override
  String get labelLastOpenFiles => '上次打开的密码库:';

  @override
  String get noFilesHaveBeenOpenYet => '尚未打开任何文件';

  @override
  String get preferenceSelectLanguage => '选择界面语言';

  @override
  String get preferenceLanguage => '界面语言';

  @override
  String get preferenceTextScaleFactor => '字体大小';

  @override
  String get preferenceVisualDensity => '图标密度';

  @override
  String get preferenceTheme => '应用程序主题';

  @override
  String get preferenceThemeLight => '明亮模式';

  @override
  String get preferenceThemeDark => '深色模式';

  @override
  String get preferenceSystemDefault => '跟随系统';

  @override
  String get preferenceDefault => '默认';

  @override
  String get lockAllFiles => '锁定所有数据库';

  @override
  String get preferenceAllowScreenshots => '允许对本应用截屏';

  @override
  String get preferenceEnableAutoFill => '启用密码自动填充';

  @override
  String get enableAutofillSuggestionBanner => '需要开启密码自动填充功能吗？';

  @override
  String get dismissAutofillSuggestionBannerButton => '不需要';

  @override
  String get enableAutofillSuggestionBannerButton => '启用！';

  @override
  String get preferenceAutoFillDescription => '仅支持安卓 8.0 (Oreo) 或更高版本。';

  @override
  String get preferenceTitle => '设置';

  @override
  String get preferenceEnableSystemWideShortcuts => '启用全局快捷键';

  @override
  String get preferenceEnableSystemWideShortcutsHelp =>
      '将 Ctrl+Alt+F 注册为打开搜索的全局快捷键';

  @override
  String get preferencesSearchFields => '自定义搜索范围';

  @override
  String get preferencesSearchFieldPromptTitle => '搜索范围';

  @override
  String get preferencesSearchFieldPromptLabel => '允许搜索的字段列表，用半角逗号分隔';

  @override
  String preferencesSearchFieldPromptHelp(
    Object wildCardCharacter,
    Object defaultSearchFields,
  ) {
    return '使用 $wildCardCharacter 代表所有字段，留空则使用默认字段 ($defaultSearchFields)';
  }

  @override
  String get aboutAppName => 'Authpass';

  @override
  String get aboutLinkFeedback => '欢迎反馈意见！';

  @override
  String get aboutLinkVisitWebsite => '别忘了参观一下我们的网站';

  @override
  String get aboutLinkGitHub => '本项目是自由开源软件！';

  @override
  String aboutLogFile(String logFilePath) {
    return '日志文件: $logFilePath';
  }

  @override
  String get aboutLinkContributors => '显示贡献者';

  @override
  String get unableToLaunchUrlTitle => '无法打开链接';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return '打开链接 $url 失败: $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler => '找不到可以打开此链接的应用程序';

  @override
  String launchedUrl(Object url) {
    return '您打开的链接是: $url';
  }

  @override
  String get menuItemGeneratePassword => '生成安全密码';

  @override
  String get menuItemPreferences => '偏好设置';

  @override
  String get menuItemOpenAnotherFile => '打开另一个数据库';

  @override
  String get menuItemCheckForUpdates => '检查更新';

  @override
  String get menuItemSupport => '发送日志';

  @override
  String get menuItemSupportSubtitle => '通过电子邮件发送日志';

  @override
  String get menuItemForum => '帮助论坛';

  @override
  String get menuItemForumSubtitle => '报告问题并获得帮助';

  @override
  String get menuItemHelp => '寻求帮助';

  @override
  String get menuItemHelpSubtitle => '在浏览器查阅用户文档';

  @override
  String get menuItemAbout => '关于本应用';

  @override
  String get actionOpenUrl => '打开链接';

  @override
  String get passwordPlainText => '显示密码';

  @override
  String get generatorPassword => '生成的密码';

  @override
  String get generatePassword => '生成随机密码';

  @override
  String get doneButtonLabel => '完成';

  @override
  String get useAsDefault => '用作默认密码';

  @override
  String get characterSetLowerCase => '小写字母 (a-z)';

  @override
  String get characterSetUpperCase => '大写字母 (A-Z)';

  @override
  String get characterSetNumeric => '数字 (0-9)';

  @override
  String get characterSetUmlauts => 'ASCII扩展字符 (ä)';

  @override
  String get characterSetSpecial => '特殊字符 (@%+)';

  @override
  String get length => '长度';

  @override
  String get customLength => '自定义密码长度';

  @override
  String customLengthHelperText(Object customMinLength) {
    return '请输入大于 $customMinLength 的整数';
  }

  @override
  String savedFiles(int numFiles, Object files) {
    final intl.NumberFormat numFilesNumberFormat =
        intl.NumberFormat.compactLong(
          locale: localeName,
        );
    final String numFilesString = numFilesNumberFormat.format(numFiles);

    String _temp0 = intl.Intl.pluralLogic(
      numFiles,
      locale: localeName,
      other: '$numFilesString 个已保存的文件: $files',
      one: '一个文件已保存: $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => '分组管理';

  @override
  String get lockFiles => '锁定文件';

  @override
  String get searchHint => '吾将上下而求索…';

  @override
  String get searchButtonLabel => '吾将上下而求索…';

  @override
  String get filterButtonLabel => '按组筛选';

  @override
  String get clear => '清空';

  @override
  String get autofillFilterPrefix => '筛选：';

  @override
  String get autofillPrompt => '选择用于自动填充的密码条目。';

  @override
  String get copiedToClipboard => '成功复制到剪贴板';

  @override
  String get noTitle => '(无标题)';

  @override
  String get noUsername => '(空空如也)';

  @override
  String get filterCustomize => '自定义…';

  @override
  String get swipeCopyPassword => '复制密码';

  @override
  String get swipeCopyUsername => '复制登录帐号';

  @override
  String get copyUsernameNotExists => '此条目缺少用户名';

  @override
  String get copyPasswordNotExists => '此条目缺少密码';

  @override
  String get doneCopiedPassword => '密码已复制到剪贴板。';

  @override
  String get doneCopiedUsername => '帐号已复制到剪贴板。';

  @override
  String get doneCopiedField => '复制成功！';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return '$fieldName 已在剪贴板待命。';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return '$fieldName 是空的。';
  }

  @override
  String get emptyPasswordVaultPlaceholder => '这里还没有密码呢';

  @override
  String get emptyPasswordVaultButtonLabel => '创建第一个密码';

  @override
  String get loading => '正在通过网络加载文件';

  @override
  String get loadingFile => '正在解锁文件';

  @override
  String get internalFile => '内部文件';

  @override
  String get internalFileSubtitle => '过去使用本应用创建的密码库';

  @override
  String get filePicker => '文件选择器';

  @override
  String get filePickerSubtitle => '从设备存储打开文件。';

  @override
  String get credentialsAppBarTitle => '解锁密码';

  @override
  String get credentialLabel => '输入这个数据库的解锁密码';

  @override
  String get masterPasswordInputLabel => '用主密码保护您的密码库';

  @override
  String get masterPasswordEmptyValidator => '欢迎回来！请在这里输入主密码';

  @override
  String get masterPasswordIncorrectValidator => '该密码无效';

  @override
  String get useKeyFile => '使用密钥文件';

  @override
  String get saveMasterPasswordBiometric => '使用生物识别保存密码？';

  @override
  String get close => '关闭';

  @override
  String get addNewPassword => '添加新密码';

  @override
  String get errorOpenFileInvalidFileStructureTitle => '打开失败，检查一下文件？';

  @override
  String errorOpenFileInvalidFileStructureBody(Object fileName) {
    return '无法打开 ($fileName)。请选择一个有效的KDBX文件，或创建一个新的。';
  }

  @override
  String get errorOpenFileAlreadyOpenTitle => '文件已被打开';

  @override
  String errorOpenFileAlreadyOpenBody(
    Object databaseName,
    Object openFileSource,
    Object newFileSource,
  ) {
    return '所选数据库 $databaseName 已经从 $openFileSource 打开(试图从 $newFileSource 打开)';
  }

  @override
  String get loadFromUrl => '从链接下载';

  @override
  String get loadFromUrlEnterUrl => '输入网址';

  @override
  String get loadFromUrlErrorEnterFullUrl => '请输入以 http:// 或 https:// 开头的完整链接';

  @override
  String get loadFromUrlErrorInvalidUrl => '请输入一个有效的链接。';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass 需要访问 Secret Service 的权限才能保存云端验证信息\n请在终端运行以下命令：';

  @override
  String get cancel => '取消';

  @override
  String get errorLoadFileFromSourceTitle => '打开文件时出错。';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return '无法打开 $source \n$error';
  }

  @override
  String get errorUnlockFileTitle => '无法打开文件';

  @override
  String errorUnlockFileBody(Object error) {
    return '尝试打开文件时发生未知错误。 $error';
  }

  @override
  String get dialogContinue => '下一步';

  @override
  String get dialogSendErrorReport => '发送错误报告';

  @override
  String get dialogReportErrorForum => '在论坛中报告错误';

  @override
  String get groupFilterDescription => '选择要显示的分组';

  @override
  String get groupFilterSelectAll => '全选';

  @override
  String get groupFilterDeselectAll => '取消全选';

  @override
  String get createSubgroup => '创建下级分组';

  @override
  String get editAction => '编辑';

  @override
  String get mailboxEnableLabel => '(重新)启用';

  @override
  String get mailboxEnableHint => '继续接收邮件';

  @override
  String get mailboxDisableLabel => '停用';

  @override
  String get mailboxDisableHint => '停止接收邮件';

  @override
  String get mailListNoMail => '您还没有部署任何代理邮箱';

  @override
  String mailboxLabelPrefixForEntry(Object entryLabel) {
    return '条目: $entryLabel';
  }

  @override
  String mailboxLabelPrefixUnknownEntry(Object entryUuid) {
    return '未知条目: $entryUuid';
  }

  @override
  String mailboxLabelPrefixCreatedAt(Object dateTime) {
    return '创建于： $dateTime';
  }

  @override
  String get masterPasswordDescription => '主密码用于加密您的密码数据库。请务必记住它，因为此密码无法恢复。';

  @override
  String get unsavedChangesWarningTitle => '稍等！';

  @override
  String get unsavedChangesWarningBody => '存在未保存的修改，要取消修改吗？';

  @override
  String get unsavedChangesDiscardActionLabel => '放弃修改';

  @override
  String get deletePermanentlyAction => '彻底删除';

  @override
  String get restoreFromRecycleBinAction => '恢复';

  @override
  String get deleteAction => '删除';

  @override
  String get deletedEntry => '条目已删除';

  @override
  String get successfullyDeletedGroup => '已删除分组。';

  @override
  String get undoButtonLabel => '撤消';

  @override
  String get saveButtonLabel => '保存';

  @override
  String get webDavSettings => '配置WebDAV';

  @override
  String get webDavUrlLabel => '链接地址';

  @override
  String get webDavUrlHelperText => 'WebDAV服务的Url';

  @override
  String get webDavUrlValidatorError => '请输入网址';

  @override
  String get webDavUrlValidatorInvalidUrlError =>
      '请输入以 http:// 或 https:// 开头的完整链接';

  @override
  String get webDavAuthUser => '用户名';

  @override
  String get webDavAuthPassword => '密码';

  @override
  String get mergeSuccessDialogTitle => '合并密码数据库成功';

  @override
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary) {
    return '保存 $fileName 时检测到冲突, 它已成功与远程文件合并: \n\n$mergeSummary';
  }

  @override
  String forDetailsVisitUrl(Object url) {
    return '详情请访问 $url';
  }

  @override
  String get authPassCloudAuthEmailInputLabel => '请输入邮箱地址以开始注册或登录';

  @override
  String get authPassCloudAuthEmailInvalid => '请输入有效的电子邮件地址。';

  @override
  String get authPassCloudAuthConfirmEmailButtonLabel => '请确认地址';

  @override
  String get authPassCloudAuthConfirmEmail => '请检查您的邮箱以确认您的代理邮件地址。';

  @override
  String get authPassCloudAuthConfirmEmailExplain =>
      '保持此界面打开，直到您成功打开从电子邮件收到的链接。';

  @override
  String get authPassCloudAuthResendExplain =>
      '如果您没有收到电子邮件，请检查您的垃圾邮件。您也可以重新发送请求。';

  @override
  String get authPassCloudAuthResendButtonLabel => '重新发送请求';

  @override
  String permanentlyDeleteEntryConfirm(Object title) {
    return '这将永久删除 $title 条目，且不能撤消。确定要这么做吗？';
  }

  @override
  String get permanentlyDeletedEntrySnackBar => '条目已被彻底删除！';

  @override
  String get initialNewGroupName => '新建分组';

  @override
  String get deleteGroupErrorTitle => '删除失败！';

  @override
  String get deleteGroupErrorBodyContainsGroup => '此分组中还包含分组！您目前只能删除空群组。';

  @override
  String get deleteGroupErrorBodyContainsEntries => '此分组中还包含密码！您目前只能删除空群组。';

  @override
  String get groupListAppBarTitle => '分组';

  @override
  String get groupListFilterAppbarTitle => '按分组筛选';

  @override
  String get clearQuickUnlock => '清除生物识别记录（如指纹）';

  @override
  String get clearQuickUnlockSubtitle => '删除已保存的主密码';

  @override
  String get unlock => '解锁';

  @override
  String get closePasswordFiles => '关闭密码文件';

  @override
  String get clearQuickUnlockSuccess => '已取消生物识别解锁';

  @override
  String get diacOptIn => '应用内消息';

  @override
  String get diacOptInSubtitle => '会偶尔连接网络获取新闻和问卷并在应用内显示';

  @override
  String get enableAutofillDebug => '启用自动填充的调试模式';

  @override
  String get enableAutofillDebugSubtitle => '为每个输入字段显示调试信息叠加层';

  @override
  String get createPasswordDatabase => '新建密码库';

  @override
  String get nameNewPasswordDatabase => '为您的新密码库命名';

  @override
  String get validatorNameMissing => '请为您的新密码库起一个名字！';

  @override
  String get masterPasswordHelpText => '设置一个安全的主密码，请务必牢记！';

  @override
  String get inputMasterPasswordText => '主密码';

  @override
  String get masterPasswordMissingCreate => '请输入一个您能记住的足够安全的密码';

  @override
  String get createDatabaseAction => '创建密码库';

  @override
  String get databaseExistsError => '已有同名文件存在';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return '创建数据库失败，已有同名文件，请尝试换一个名字。\n出错位置: $filePath';
  }

  @override
  String get databaseCreateDefaultName => '我的密码';

  @override
  String get preferenceDynamicLoadIcons => '联网加载图标';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return '将会向$urlFieldName发送未加密的http请求来获取网页图标';
  }

  @override
  String passwordScore(Object score) {
    return '密码强度: $score / 4';
  }

  @override
  String get entryInfoFile => '文件：';

  @override
  String get entryInfoGroup => '分组:';

  @override
  String get entryInfoLastModified => '最后修改时间：';

  @override
  String movedEntryToGroup(Object groupName) {
    return '移动条目到 $groupName';
  }

  @override
  String sizeBytesStoredAuthPassCloud(Object count) {
    return '$count 字节，已保存到AuthPass Cloud';
  }

  @override
  String sizeBytes(Object count) {
    return '$count 字节';
  }

  @override
  String get entryAddAttachment => '添加附件';

  @override
  String get entryAttachmentSizeWarning =>
      '附件可以是任何文件，它将与密码文件结合，这会大大增加打开/保存密码所需的时间。';

  @override
  String get iconPngSizeWarning => '自定义图标将合并入密码数据库。这会增加打开/保存密码所需的时间。';

  @override
  String get notPngError => '只支持PNG格式';

  @override
  String get entryAddField => '添加项目';

  @override
  String get entryCustomField => '自定义字段';

  @override
  String get entryCustomFieldTitle => '添加新自定义字段';

  @override
  String get entryCustomFieldInputLabel => '输入字段名称';

  @override
  String get swipeCopyField => '复制项目';

  @override
  String get fieldRename => '重命名';

  @override
  String get fieldGeneratePassword => '生成随机密码…';

  @override
  String get fieldProtect => '锁定';

  @override
  String get fieldUnprotect => '取消锁定';

  @override
  String get fieldPresent => '显示二维码';

  @override
  String get fieldGenerateEmail => '生成电子邮箱地址';

  @override
  String get onboardingBackToOnboarding => '时间回溯';

  @override
  String get onboardingBackToOnboardingSubtitle => '回到初始引导界面';

  @override
  String get onboardingHeadline => '守护您的密码安全！';

  @override
  String get onboardingQuestion =>
      '您之前用过本软件\n或其他兼容KeePass的密码管理器吗？\n（如KeepassDX、KeepassXC等）';

  @override
  String get onboardingYesOpenPasswords => '使用已有的KDBX文件';

  @override
  String get onboardingNoCreate => '新建KDBX密码库';

  @override
  String get backupButton => '保存到云端';

  @override
  String get dismissBackupButton => '不需要';

  @override
  String backupWarningMessage(Object databasename) {
    return '$databasename 密码库中的密码没有上传到云端！';
  }

  @override
  String get saveAs => '保存到…';

  @override
  String get saving => '正在保存…';

  @override
  String get increaseValue => '增加';

  @override
  String get decreaseValue => '减少';

  @override
  String get resetValue => '重置';

  @override
  String cloudStorageAppBarTitle(Object cloudStorageName) {
    return '云存储 - $cloudStorageName';
  }

  @override
  String get cloudStorageLogInCaption => '即将为您打开AuthPass验证界面，验证后即可获取您的数据';

  @override
  String get cloudStorageLogInCode => '输入验证码';

  @override
  String launchUrlError(Object url) {
    return '无法访问链接: $url';
  }

  @override
  String cloudStorageLogInActionLabel(Object cloudStorageName) {
    return '登录 $cloudStorageName 账号';
  }

  @override
  String cloudStorageAuthCodeDialogTitle(Object cloudStorageName) {
    return '$cloudStorageName - 身份验证';
  }

  @override
  String get cloudStorageAuthCodeLabel => '身份验证码';

  @override
  String get cloudStorageAuthErrorTitle => '抱歉，验证出错了，再试一次？';

  @override
  String cloudStorageAuthErrorMessage(
    Object cloudStorageName,
    Object errorMessage,
  ) {
    return '尝试认证到 $cloudStorageName 时出错： \n$errorMessage';
  }

  @override
  String get cloudStorageSearchBoxLabel => '路漫漫其修远兮…';

  @override
  String cloudStorageItemsInFolder(Object itemCount) {
    return '共有 $itemCount 个条目。';
  }

  @override
  String get mailSubject => '主题';

  @override
  String get mailFrom => '发件人：';

  @override
  String get mailDate => '日期:';

  @override
  String get mailMailbox => '全部代理邮箱';

  @override
  String get mailNoData => '没有内容，或被加密/已损坏';

  @override
  String get mailMailboxesTitle => '全部代理邮箱';

  @override
  String get mailboxCreateButtonLabel => '新建';

  @override
  String get mailboxNameInputDialogTitle => '为新邮箱命名（可选）';

  @override
  String get mailboxNameInputLabel => '（内部）名称';

  @override
  String get mailScreenTitle => 'AuthPass - 代理邮箱';

  @override
  String get mailTabBarTitleMailbox => '邮箱列表';

  @override
  String get mailTabBarTitleMail => '邮件列表';

  @override
  String get mailMailboxListEmpty => '还没有部署任何代理邮箱';

  @override
  String mailMailboxAddressCopied(Object mailboxAddress) {
    return '已复制邮箱地址到剪贴板: $mailboxAddress';
  }

  @override
  String get errorWhileSavingTitle => '保存时出错！';

  @override
  String errorWhileSavingBody(Object errorMessage) {
    return '无法保存文件: $errorMessage';
  }

  @override
  String get databaseDoesNotSupportSaving =>
      '抱歉，无法保存到此数据库。请打开本地数据库文件，或者选择“另存为”。';

  @override
  String get otpInvalidKeyTitle => '无效密钥！';

  @override
  String get otpInvalidKeyBody => '此代码无效，请检查您的输入';

  @override
  String get otpUnsupportedMigrationTitle => 'Unsupported OTP Migration';

  @override
  String otpUnsupportedMigrationBody(Object uriCount) {
    return 'We currently only support single item migrations. Got $uriCount';
  }

  @override
  String get otpPromptTitle => '基于时间的身份认证';

  @override
  String get otpPromptHelperText => '请输入TOTP密钥';

  @override
  String otpErrorMessageGeneration(Object errorMessage) {
    return '生成邀请码时出错: $errorMessage';
  }

  @override
  String get otpCopySecretActionLabel => '复制此密钥';

  @override
  String get otpEntryLabel => '一次性口令（TOTP）';

  @override
  String get entryFieldProtected => '受保护区域。点击以显示。';

  @override
  String get entryFieldActionRevealField => '展开受保护区域';

  @override
  String get entryAttachmentOpenActionLabel => '打开';

  @override
  String get entryAttachmentShareActionLabel => '分享';

  @override
  String get entryAttachmentShareSubject => '附件';

  @override
  String get entryAttachmentSaveActionLabel => '保存到设备';

  @override
  String get entryAttachmentRemoveActionLabel => '移除';

  @override
  String entryAttachmentRemoveConfirm(Object attachmentLabel) {
    return '确定要删除 $attachmentLabel 吗？';
  }

  @override
  String get entryRenameFieldPromptTitle => '重命名字段';

  @override
  String get removerecentfile => '移除';

  @override
  String get entryRenameFieldPromptLabel => '输入新字段名称';

  @override
  String get promptDialogPasteActionTooltip => '从剪贴板中粘贴';

  @override
  String get promptDialogPasteHint => '小贴士：您可以使用左侧按钮进行粘贴';

  @override
  String get genericErrorDialogTitle => '处理操作时出错';

  @override
  String genericErrorDialogBody(Object errorMessage) {
    return '发生意外错误。 $errorMessage';
  }

  @override
  String get saveAsEntryLocalFile => '本地文件';

  @override
  String get fileTypePngs => '图像(png)';

  @override
  String get selectIconDialogAction => '选择图标';

  @override
  String get retryDialogActionLabel => '重试';

  @override
  String errorDuringNetworkCall(Object errorMessage) {
    return '调用api时出错。 $errorMessage';
  }

  @override
  String get passwordFilterHideDeleted => '隐藏已删除条目';

  @override
  String get passwordFilterOnlyDeleted => '已删除条目';

  @override
  String passwordFilterPrefixForOneGroup(Object groupName) {
    return '群组: $groupName';
  }

  @override
  String passwordFilterPrefixForMultipleGroups(Object groupCount) {
    return '自定义筛选器 ($groupCount 组)';
  }

  @override
  String get menuItemAuthPassCloudAuthenticate => '使用 AuthPass Cloud 验证';

  @override
  String get menuItemAuthPassCloudMailboxes => 'AuthPass - 代理邮箱';

  @override
  String changesWithoutSaving(Object fileName) {
    return '您对 \"$fileName\"进行了修改，但其不支持写入更改。';
  }

  @override
  String get changesSaveLocally => '保存到本地';

  @override
  String get clearColor => '清除颜色';

  @override
  String get databaseRenameInputLabel => '输入数据库名称';

  @override
  String get databasePath => '路径';

  @override
  String get databaseColor => '颜色';

  @override
  String get databaseColorChoose => '选择一种颜色用以区分多个文件';

  @override
  String get databaseKdbxVersion => 'KDBX文件版本';

  @override
  String databaseKdbxUpgradeVersion(Object versionName) {
    return '升级到 $versionName';
  }

  @override
  String get databaseKdbxUpgradeSuccessful => '升级成功，文件已保存';

  @override
  String get databaseReload => '重新载入并合并';

  @override
  String progressStatus(Object statusProgress) {
    return '状态: $statusProgress';
  }

  @override
  String finishedMerge(Object status) {
    return '已完成合并 $status';
  }

  @override
  String get closeAndLockFile => '关闭/锁定';

  @override
  String get authPassHomeScreenTagline => '密码管理器，开放源代码，可在所有平台上使用。';

  @override
  String get addNewPasswordButtonLabel => '添加新的密码';

  @override
  String get unnamedEntryPlaceholder => '(未命名)';

  @override
  String get unnamedGroupPlaceholder => '(未命名)';

  @override
  String get unnamedFilePlaceholder => '(未命名)';

  @override
  String get editGroupScreenTitle => '编辑群组';

  @override
  String get editGroupGroupNameLabel => '群组名称';

  @override
  String get files => '文件';

  @override
  String get newGroupDialogTitle => '新建分组';

  @override
  String get newGroupDialogInputLabel => '新群组名称';

  @override
  String get groupActionShowPasswords => '显示密码';

  @override
  String get groupActionDelete => '删除';

  @override
  String get logoutTooltip => '登出';

  @override
  String get successfullyDeletedFileCloudStorage => '删除文件成功';

  @override
  String shareDialogTitle(Object fileName) {
    return '发送 $fileName';
  }

  @override
  String get shareFileActionLabel => '分享';

  @override
  String get shareTokenListEmptyScreenPlaceholder => '文件尚未共享。';

  @override
  String get shareTokenNoLabel => '无 标签/说明';

  @override
  String get shareTokenReadWrite => '读/写';

  @override
  String get shareTokenReadOnly => '只读';

  @override
  String get shareCreateTokenDialogTitle => '共享文件';

  @override
  String get shareCreateTokenReadOnly => '只读';

  @override
  String get shareCreateTokenReadOnlyHelpText => '不允许保存更改';

  @override
  String get shareCreateTokenLabelText => '说明';

  @override
  String get shareCreateTokenLabelHint => '分享给我的朋友';

  @override
  String get shareCreateTokenLabelHelp => '可选标签用以区分共享口令';

  @override
  String get shareCreateTokenSuccess => '成功创建私密共享口令';

  @override
  String get sharePresentDialogTitle => '通过私密分享共令分享文件';

  @override
  String get sharePresentDialogHelp =>
      '使用以下共享口令用户可以访问数据库文件。他们需要密码 和/或 密钥文件来打开它。';

  @override
  String get sharePresentToken => '共享口令';

  @override
  String get sharePresentCopied => '共享口令已复制到剪贴板';

  @override
  String get authPassCloudOpenWithShareCodeTooltip => '使用私密共享口令打开';

  @override
  String get authPassCloudShareFileActionLabel => '分享';

  @override
  String get preferenceAuthPassCloudAttachmentTitle => '使用AuthPass Cloud附件';

  @override
  String get preferenceAuthPassCloudAttachmentSubtitle =>
      '将附件加密保存到AuthPass Cloud。';

  @override
  String get shareCodeInputDialogTitle => '输入私密共享口令';

  @override
  String get shareCodeInputDialogScan => '扫描二维码';

  @override
  String get shareCodeInputLabel => '私密共享口令';

  @override
  String get shareCodeInputHelperText => '如果您收到了一个共享口令，请将其粘贴在上面。';

  @override
  String get shareCodeOpen => '收到了AuthPass Cloud的共享口令？';

  @override
  String get shareCodeOpenScreenTitle => '通过共享口令加载文件';

  @override
  String get shareCodeLoadingProgress => '正在加载文件…';

  @override
  String get shareCodeOpenFileButtonLabel => '打开';

  @override
  String get shareCodeOpenInstallAppCaption => '想用我们的本地应用程序打开此文件吗？';

  @override
  String get shareCodeOpenAnotherAppCaption => '想在其他设备上打开此文件吗？';

  @override
  String get shareCodeOpenInstallAppButtonLabel => '安装应用';

  @override
  String get shareCodeOpenShowCodeButtonLabel => '显示共享口令';

  @override
  String get changeMasterPasswordActionLabel => '更改主密码';

  @override
  String get changeMasterPasswordFormSubmit => '使用新密码保存';

  @override
  String get changeMasterPasswordSuccess => '成功保存主密码。';

  @override
  String get changeMasterPasswordScreenTitle => '更改主密码';

  @override
  String get authPassCloudAuthClickedLink => '我已收到电子邮件并访问了链接';

  @override
  String get authPassCloudAuthNotConfirmed =>
      '邮箱地址尚未确认。请确保点击您收到的电子邮件中的链接并通过验证以便确认您的电子邮箱地址。';

  @override
  String get getHelpButton => '在论坛中寻求帮助';

  @override
  String get shortcutCopyUsername => '复制登录帐号';

  @override
  String get shortcutCopyPassword => '复制密码';

  @override
  String get shortcutCopyTotp => '复制TOTP码';

  @override
  String get shortcutMoveUp => '选择上一个密码';

  @override
  String get shortcutMoveDown => '选择下一个密码';

  @override
  String get shortcutGeneratePassword => '生成随机密码';

  @override
  String get shortcutCopyUrl => '复制链接';

  @override
  String get shortcutOpenUrl => '打开链接';

  @override
  String get shortcutCancelSearch => '取消搜索';

  @override
  String get shortcutShortcutHelp => '键盘快捷键帮助';

  @override
  String get shortcutHelpTitle => '快捷键';

  @override
  String unexpectedError(String error) {
    return '意外错误: $error';
  }

  @override
  String get googleDriveMorePermissionsRequired =>
      'Additional permissions needed to access Google Drive.';

  @override
  String get googleDriveRequestPermissionButtonLabel => 'Request Permissions';

  @override
  String get scanQrCodeTitle => 'Scan QR Code.';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get fieldUserName => '帳號名稱';

  @override
  String get fieldPassword => '密碼';

  @override
  String get fieldWebsite => '網站';

  @override
  String get fieldTitle => '顯示標題';

  @override
  String get fieldTotp => '單次密碼（OTP，依時間變化）';

  @override
  String get english => '英文';

  @override
  String get german => '德文';

  @override
  String get russian => '俄文';

  @override
  String get ukrainian => '烏克蘭文';

  @override
  String get lithuanian => '立陶宛文';

  @override
  String get french => '法文';

  @override
  String get spanish => '西班牙文';

  @override
  String get indonesian => '印尼文';

  @override
  String get turkish => '土耳其文';

  @override
  String get hebrew => '希伯來文';

  @override
  String get italian => '義大利文';

  @override
  String get chineseSimplified => '簡體中文';

  @override
  String get chineseTraditional => '正體中文';

  @override
  String get portugueseBrazilian => '葡萄牙文（巴西）';

  @override
  String get slovak => '斯洛伐克語';

  @override
  String get dutch => '荷蘭語';

  @override
  String get selectItem => '選取';

  @override
  String get selectKeepassFile => 'AuthPass - 選取 KeePass 格式檔';

  @override
  String get selectKeepassFileLabel => '請選擇 KeePass（.kdbx）格式檔。';

  @override
  String get createNewFile => '建立新密碼檔';

  @override
  String get openLocalFile => '開啟\n本機檔案';

  @override
  String get openFile => '開啟檔案';

  @override
  String get loadFromDropdownMenu => '從其他來源加載...';

  @override
  String get quickUnlockingFiles => '快速解鎖…';

  @override
  String openFileProgress(Object fileName, Object current, Object totalCount) {
    return '$fileName';
  }

  @override
  String loadFrom(String cloudStorageName) {
    return '開啟雲端檔案 $cloudStorageName';
  }

  @override
  String get loadFromRemoteUrl => '自 URL 開啟 kdbx 檔';

  @override
  String get createNewKeepass => 'KeePass 新手嗎？\n建立新的檔案資料庫';

  @override
  String get labelLastOpenFiles => '上次開啟檔案：';

  @override
  String get noFilesHaveBeenOpenYet => '尚未開啟任何檔案。';

  @override
  String get preferenceSelectLanguage => '選擇語言';

  @override
  String get preferenceLanguage => '語言設定';

  @override
  String get preferenceTextScaleFactor => '文字尺寸';

  @override
  String get preferenceVisualDensity => '行距';

  @override
  String get preferenceTheme => '佈景主題';

  @override
  String get preferenceThemeLight => '淺色';

  @override
  String get preferenceThemeDark => '深色';

  @override
  String get preferenceSystemDefault => '系統預設';

  @override
  String get preferenceDefault => '預設值';

  @override
  String get lockAllFiles => '鎖定所有開啟中的檔案';

  @override
  String get preferenceAllowScreenshots => '允許在 App 畫面截圖';

  @override
  String get preferenceEnableAutoFill => '啟用自動填入';

  @override
  String get enableAutofillSuggestionBanner => '您可以啟用自動填充來填寫其他應用程序中的字段！';

  @override
  String get dismissAutofillSuggestionBannerButton => '關閉';

  @override
  String get enableAutofillSuggestionBannerButton => '啟用！';

  @override
  String get preferenceAutoFillDescription => '僅 Android Oreo（8.0）以上支援此功能。';

  @override
  String get preferenceTitle => '偏好設定';

  @override
  String get preferencesSearchFields => '自定義搜索字段';

  @override
  String get preferencesSearchFieldPromptTitle => '搜索字段';

  @override
  String get aboutAppName => 'AuthPass';

  @override
  String get aboutLinkFeedback => '歡迎指教！';

  @override
  String get aboutLinkVisitWebsite => '記得上我們的網站';

  @override
  String get aboutLinkGitHub => '還有開源專案';

  @override
  String aboutLogFile(String logFilePath) {
    return '記錄檔： $logFilePath';
  }

  @override
  String get aboutLinkContributors => '顯示貢獻者';

  @override
  String get unableToLaunchUrlTitle => '無法開啟 URL';

  @override
  String unableToLaunchUrlDescription(Object url, Object openError) {
    return '無法開啟 $url： $openError';
  }

  @override
  String get unableToLaunchUrlNoHandler => '沒有適合開啟該 URL 的軟體';

  @override
  String launchedUrl(Object url) {
    return '開啟的 URL：$url';
  }

  @override
  String get menuItemGeneratePassword => '產生密碼';

  @override
  String get menuItemPreferences => '偏好設定';

  @override
  String get menuItemOpenAnotherFile => '開啟其他檔案';

  @override
  String get menuItemCheckForUpdates => '檢查更新';

  @override
  String get menuItemSupport => '發送日誌';

  @override
  String get menuItemSupportSubtitle => '通過電子郵件發送日誌';

  @override
  String get menuItemForum => '支援論壇';

  @override
  String get menuItemForumSubtitle => '報告問題並獲得幫助';

  @override
  String get menuItemHelp => '說明';

  @override
  String get menuItemHelpSubtitle => '開啟說明文件';

  @override
  String get menuItemAbout => '關於';

  @override
  String get actionOpenUrl => '開啟 URL';

  @override
  String get passwordPlainText => '顯示密碼';

  @override
  String get generatorPassword => '密碼';

  @override
  String get generatePassword => '產生密碼';

  @override
  String get doneButtonLabel => '完成';

  @override
  String get useAsDefault => '存為預設值';

  @override
  String get characterSetLowerCase => '小寫英文（a-z）';

  @override
  String get characterSetUpperCase => '大寫英文（A-Z）';

  @override
  String get characterSetNumeric => '數字（0-9）';

  @override
  String get characterSetUmlauts => '變音字母（ä）';

  @override
  String get characterSetSpecial => '特殊字元（@%+）';

  @override
  String get length => '字數';

  @override
  String get customLength => '自訂字數';

  @override
  String customLengthHelperText(Object customMinLength) {
    return '僅供超過 $customMinLength 字時使用';
  }

  @override
  String savedFiles(int numFiles, Object files) {
    final intl.NumberFormat numFilesNumberFormat =
        intl.NumberFormat.compactLong(
          locale: localeName,
        );
    final String numFilesString = numFilesNumberFormat.format(numFiles);

    String _temp0 = intl.Intl.pluralLogic(
      numFiles,
      locale: localeName,
      other: '已儲存 $numFilesString 個檔案： $files',
    );
    return '$_temp0';
  }

  @override
  String get manageGroups => '管理群組';

  @override
  String get lockFiles => '鎖住檔案';

  @override
  String get searchHint => '搜尋';

  @override
  String get searchButtonLabel => '搜尋';

  @override
  String get filterButtonLabel => '篩選群組';

  @override
  String get clear => '清除篩選條件';

  @override
  String get autofillFilterPrefix => '篩選：';

  @override
  String get autofillPrompt => '選擇密碼以填入';

  @override
  String get copiedToClipboard => '複製到剪貼簿。';

  @override
  String get noTitle => '（無顯示標題）';

  @override
  String get noUsername => '（無帳號名稱）';

  @override
  String get filterCustomize => '自訂篩選 …';

  @override
  String get swipeCopyPassword => '複製密碼';

  @override
  String get swipeCopyUsername => '複製帳號';

  @override
  String get copyUsernameNotExists => '此條目沒有定義用戶名。';

  @override
  String get copyPasswordNotExists => '此條目沒有定義密碼。';

  @override
  String get doneCopiedPassword => '已將密碼複製到剪貼簿。';

  @override
  String get doneCopiedUsername => '已將帳號複製到剪貼簿。';

  @override
  String get doneCopiedField => '已複製。';

  @override
  String copiedFieldToClipboard(Object fieldName) {
    return '$fieldName 已被複製';
  }

  @override
  String copiedFieldEmpty(Object fieldName) {
    return '$fieldName 為空。';
  }

  @override
  String get emptyPasswordVaultPlaceholder => '目前資料庫中沒有任何密碼。';

  @override
  String get emptyPasswordVaultButtonLabel => '記下第一組密碼';

  @override
  String get loading => '正在加載';

  @override
  String get loadingFile => '檔案讀取中 …';

  @override
  String get internalFile => '內部檔案';

  @override
  String get internalFileSubtitle => '先前以 AuthPass 建立的資料庫';

  @override
  String get filePicker => '選擇檔案';

  @override
  String get filePickerSubtitle => '自本機開啟檔案。';

  @override
  String get credentialsAppBarTitle => '驗證資訊';

  @override
  String get credentialLabel => '輸入密碼，開啟資料庫';

  @override
  String get masterPasswordInputLabel => '密碼';

  @override
  String get masterPasswordEmptyValidator => '請輸入密碼。';

  @override
  String get masterPasswordIncorrectValidator => '密碼錯誤';

  @override
  String get useKeyFile => '使用金鑰檔';

  @override
  String get saveMasterPasswordBiometric => '以生物驗證儲存檔案密碼？';

  @override
  String get close => '關閉';

  @override
  String get addNewPassword => '新增密碼';

  @override
  String get errorOpenFileAlreadyOpenTitle => '這個檔案早已開啟了';

  @override
  String errorOpenFileAlreadyOpenBody(
    Object databaseName,
    Object openFileSource,
    Object newFileSource,
  ) {
    return '您選的資料庫 $databaseName 早已自$openFileSource 開啟（您正試圖從$newFileSource 再度開啟）';
  }

  @override
  String get loadFromUrl => '從網址下載';

  @override
  String get loadFromUrlEnterUrl => '輸入網址';

  @override
  String get loadFromUrlErrorEnterFullUrl => '請輸入以 http:// 或 https:// 開頭的完整網址';

  @override
  String get loadFromUrlErrorInvalidUrl => '請輸入有效網址。';

  @override
  String get linuxAppArmorWarning =>
      'AuthPass 需要與 Secret Service 通信以存儲雲存儲憑據的權限。\n請運行以下命令：';

  @override
  String get cancel => '取消';

  @override
  String get errorLoadFileFromSourceTitle => '打開文件時出錯。';

  @override
  String errorLoadFileFromSourceBody(Object source, Object error) {
    return '無法打開 $source\n$error';
  }

  @override
  String get errorUnlockFileTitle => '無法開啟檔案';

  @override
  String errorUnlockFileBody(Object error) {
    return '開啟檔案時發生不明錯誤：$error';
  }

  @override
  String get dialogContinue => '繼續';

  @override
  String get dialogSendErrorReport => '發送錯誤報告';

  @override
  String get dialogReportErrorForum => '在論壇/幫助中報告錯誤';

  @override
  String get groupFilterDescription => '選擇要顯示的群組（包含子群組）';

  @override
  String get groupFilterSelectAll => '全選';

  @override
  String get groupFilterDeselectAll => '全部不選';

  @override
  String get createSubgroup => '建立子群組';

  @override
  String get editAction => '編輯';

  @override
  String get mailboxEnableLabel => '（重新）啟用';

  @override
  String get mailboxEnableHint => '繼續接收電子郵件';

  @override
  String get mailboxDisableLabel => '禁用';

  @override
  String get mailboxDisableHint => '不再接收電子郵件';

  @override
  String get mailListNoMail => '您還沒有任何電子郵件。';

  @override
  String mailboxLabelPrefixUnknownEntry(Object entryUuid) {
    return '未知條目: $entryUuid';
  }

  @override
  String mailboxLabelPrefixCreatedAt(Object dateTime) {
    return '創建於: $dateTime';
  }

  @override
  String get masterPasswordDescription => '主密碼用於安全地加密您的密碼數據庫。 請務必記住它，它無法被恢復。';

  @override
  String get unsavedChangesWarningTitle => '未保存的更改';

  @override
  String get unsavedChangesWarningBody => '仍有未保存的更改。 是否要放棄更改？';

  @override
  String get unsavedChangesDiscardActionLabel => '放棄更改';

  @override
  String get deletePermanentlyAction => '永久刪除';

  @override
  String get restoreFromRecycleBinAction => '恢復';

  @override
  String get deleteAction => '刪除';

  @override
  String get deletedEntry => '已刪除條目。';

  @override
  String get successfullyDeletedGroup => '群組已刪除。';

  @override
  String get undoButtonLabel => '復原';

  @override
  String get saveButtonLabel => '儲存';

  @override
  String get webDavSettings => 'WebDAV設定';

  @override
  String get webDavUrlLabel => '網址';

  @override
  String get webDavUrlHelperText => 'WebDAV 服務的基礎 URL。';

  @override
  String get webDavUrlValidatorError => '請輸入網址';

  @override
  String get webDavUrlValidatorInvalidUrlError =>
      '請輸入以 http:// 或 https:// 開頭的有效網址';

  @override
  String get webDavAuthUser => '用戶名';

  @override
  String get webDavAuthPassword => '密碼';

  @override
  String get mergeSuccessDialogTitle => '成功合併密碼數據庫';

  @override
  String mergeSuccessDialogMessage(Object fileName, Object mergeSummary) {
    return '保存 $fileName 時檢測到衝突，它與遠程文件成功合併：\n\n$mergeSummary';
  }

  @override
  String forDetailsVisitUrl(Object url) {
    return '有關詳細信息，請訪問 $url';
  }

  @override
  String get authPassCloudAuthEmailInputLabel => '輸入電子郵件地址以註冊或登錄。';

  @override
  String get authPassCloudAuthEmailInvalid => '請輸入有效的電子郵件地址。';

  @override
  String get authPassCloudAuthConfirmEmailButtonLabel => '確認地址';

  @override
  String get authPassCloudAuthConfirmEmail => '請檢查您的電子郵件以確認您的電子郵件地址。';

  @override
  String get authPassCloudAuthConfirmEmailExplain =>
      '將此界面保持開啟，直到您已訪問通過電子郵件收到的鏈接。';

  @override
  String get authPassCloudAuthResendExplain =>
      '如果您沒有收到電子郵件，請檢查您的垃圾郵件文件夾。 否則，您可以嘗試請求新的確認鏈接。';

  @override
  String get authPassCloudAuthResendButtonLabel => '請求新的確認鏈接';

  @override
  String permanentlyDeleteEntryConfirm(Object title) {
    return '這將永久刪除密碼條目 $title 。這不能被撤消。確認要繼續嗎？';
  }

  @override
  String get permanentlyDeletedEntrySnackBar => '條目已被永久刪除';

  @override
  String get initialNewGroupName => '新群組';

  @override
  String get deleteGroupErrorTitle => '無法刪除群組';

  @override
  String get deleteGroupErrorBodyContainsGroup =>
      '此群組下還有其他子群組，無法刪除。目前只能刪除不含任何內容的群組。';

  @override
  String get deleteGroupErrorBodyContainsEntries =>
      '此群組下還存有密碼資料，無法刪除。目前只能刪除不含任何內容的群組。';

  @override
  String get groupListAppBarTitle => '群組清單';

  @override
  String get groupListFilterAppbarTitle => '選擇要顯示的群組';

  @override
  String get clearQuickUnlock => '清除生物辨識資訊';

  @override
  String get clearQuickUnlockSubtitle => '不再記憶主密碼';

  @override
  String get unlock => '檔案解鎖';

  @override
  String get closePasswordFiles => '關閉密碼檔';

  @override
  String get clearQuickUnlockSuccess => '自生物驗證資料裡刪除存下的主密碼。';

  @override
  String get diacOptIn => '顯示本軟體的新知及問卷調查';

  @override
  String get diacOptInSubtitle => '啟用後，軟體偶爾會連線擷取最新消息資料';

  @override
  String get enableAutofillDebug => '自動填入：除錯模式';

  @override
  String get enableAutofillDebugSubtitle => '顯示每個輸入欄的資訊';

  @override
  String get createPasswordDatabase => '建立密碼資料庫';

  @override
  String get nameNewPasswordDatabase => '新資料庫名稱';

  @override
  String get validatorNameMissing => '請輸入新資料庫的名稱。';

  @override
  String get masterPasswordHelpText => '選擇安全的資料庫主密碼，並且確實記牢。';

  @override
  String get inputMasterPasswordText => '主密碼';

  @override
  String get masterPasswordMissingCreate => '請輸入安全、記得著的密碼。';

  @override
  String get createDatabaseAction => '建立資料庫';

  @override
  String get databaseExistsError => '已有同名檔案';

  @override
  String databaseExistsErrorDescription(Object filePath) {
    return '建立資料庫 $filePath 時發生錯誤：已有同名檔案存在，請換個名字。';
  }

  @override
  String get databaseCreateDefaultName => 'PersonalPasswords';

  @override
  String get preferenceDynamicLoadIcons => '載入網站圖示';

  @override
  String preferenceDynamicLoadIconsSubtitle(Object urlFieldName) {
    return '將產生 HTTP 連線到 $urlFieldName 欄位指定的網站，以讀取網站圖示。';
  }

  @override
  String passwordScore(Object score) {
    return '密碼強度：$score （滿分為 4）';
  }

  @override
  String get entryInfoFile => '檔案：';

  @override
  String get entryInfoGroup => '群組：';

  @override
  String get entryInfoLastModified => '修改時間：';

  @override
  String movedEntryToGroup(Object groupName) {
    return '已將此項目移入$groupName';
  }

  @override
  String sizeBytes(Object count) {
    return '$count 位元組';
  }

  @override
  String get entryAddAttachment => '新增附件';

  @override
  String get entryAttachmentSizeWarning => '附件會存入密碼資料庫檔案中，也可能大幅拉長存取密碼所需的時間。';

  @override
  String get iconPngSizeWarning => '自訂圖示會存入密碼資料庫檔案中，也可能大幅拉長存取密碼所需的時間。';

  @override
  String get notPngError => '您選擇的檔案並非 PNG 格式';

  @override
  String get entryAddField => '新增欄位';

  @override
  String get entryCustomField => '自訂欄位';

  @override
  String get entryCustomFieldTitle => '新增自訂的欄位';

  @override
  String get entryCustomFieldInputLabel => '輸入欄位名稱';

  @override
  String get swipeCopyField => '複製內容';

  @override
  String get fieldRename => '重新命名';

  @override
  String get fieldGeneratePassword => '產生密碼…';

  @override
  String get fieldProtect => '隱藏內容';

  @override
  String get fieldUnprotect => '不必隱藏內容';

  @override
  String get fieldPresent => '展示 QRCode';

  @override
  String get fieldGenerateEmail => '產生 Email';

  @override
  String get onboardingBackToOnboarding => '概覽';

  @override
  String get onboardingBackToOnboardingSubtitle => '重現新手引領畫面 😅️';

  @override
  String get onboardingHeadline => '妥善保護您的密碼！';

  @override
  String get onboardingQuestion => '您是否用過密碼管理工具？';

  @override
  String get onboardingYesOpenPasswords => '是，我要使用先前的資料';

  @override
  String get onboardingNoCreate => '沒有，該怎麼開始呢？';

  @override
  String get backupButton => '存到雲端';

  @override
  String get dismissBackupButton => '關閉';

  @override
  String backupWarningMessage(Object databasename) {
    return '$databasename 中的密碼僅僅存在本機中！';
  }

  @override
  String get saveAs => '儲存到...';

  @override
  String get saving => '儲存中';

  @override
  String get increaseValue => '增加';

  @override
  String get decreaseValue => '減少';

  @override
  String get resetValue => '重新設定';

  @override
  String get cloudStorageLogInCaption => '您將被重定向到驗證 AuthPass 以訪問您的數據。';

  @override
  String get cloudStorageLogInCode => '輸入代碼';

  @override
  String launchUrlError(Object url) {
    return '無法啟動網址。請訪問$url';
  }

  @override
  String cloudStorageLogInActionLabel(Object cloudStorageName) {
    return '登錄到 $cloudStorageName';
  }

  @override
  String get cloudStorageAuthCodeLabel => '驗證碼';

  @override
  String get cloudStorageAuthErrorTitle => '驗證時出錯';

  @override
  String get cloudStorageSearchBoxLabel => '搜索查詢';

  @override
  String get mailSubject => '主題';

  @override
  String get mailFrom => '發件人';

  @override
  String get mailDate => '日期';

  @override
  String get mailMailbox => '郵箱';

  @override
  String get mailNoData => '沒有數據';

  @override
  String get mailMailboxesTitle => '郵箱';

  @override
  String get mailboxCreateButtonLabel => '創建';

  @override
  String get mailScreenTitle => 'AuthPass 郵箱';

  @override
  String get mailTabBarTitleMailbox => '郵箱';

  @override
  String get mailTabBarTitleMail => '郵件';

  @override
  String get mailMailboxListEmpty => '您還沒有任何郵箱。';

  @override
  String mailMailboxAddressCopied(Object mailboxAddress) {
    return '成功將郵箱地址複製到剪貼板： $mailboxAddress';
  }

  @override
  String get errorWhileSavingTitle => '保存時出錯';

  @override
  String errorWhileSavingBody(Object errorMessage) {
    return '無法保存文件： $errorMessage';
  }

  @override
  String get databaseDoesNotSupportSaving =>
      '抱歉，此數據庫不支持保存。請打開一個本地數據庫文件。或使用“另存為”。';

  @override
  String get otpInvalidKeyTitle => '無效密鑰';

  @override
  String get otpInvalidKeyBody => '給定的輸入不是有效的 base32 TOTP 代碼。請驗證您的輸入。';

  @override
  String get otpPromptTitle => '基於時間的身份驗證';

  @override
  String get otpPromptHelperText => '請輸入基於時間的密鑰。';

  @override
  String get entryFieldProtected => '受保護的領域。點擊揭示。';

  @override
  String get entryFieldActionRevealField => '顯示受保護的字段';

  @override
  String get entryAttachmentOpenActionLabel => '打開';

  @override
  String get entryAttachmentShareActionLabel => '分享';

  @override
  String get entryAttachmentShareSubject => '附件';

  @override
  String get entryAttachmentSaveActionLabel => '保存到設備';

  @override
  String get entryAttachmentRemoveActionLabel => '移除';

  @override
  String entryAttachmentRemoveConfirm(Object attachmentLabel) {
    return '確定要刪除 $attachmentLabel 嗎？';
  }

  @override
  String get entryRenameFieldPromptTitle => '重命名字段';

  @override
  String get removerecentfile => '隱藏';

  @override
  String get entryRenameFieldPromptLabel => '輸入字段的新名稱';

  @override
  String get promptDialogPasteActionTooltip => '從剪貼板粘貼';

  @override
  String get promptDialogPasteHint => '提示：如果您需要粘貼，不妨嘗試左邊的按鈕 ;-)';

  @override
  String get genericErrorDialogTitle => '處理動作時出錯';

  @override
  String genericErrorDialogBody(Object errorMessage) {
    return '發生意外錯誤：$errorMessage';
  }

  @override
  String get saveAsEntryLocalFile => '本機檔案';

  @override
  String get newGroupDialogTitle => '新群組';

  @override
  String get groupActionDelete => '刪除';

  @override
  String get shareCodeLoadingProgress => '檔案讀取中 …';

  @override
  String get shortcutCopyUsername => '複製帳號';

  @override
  String get shortcutCopyPassword => '複製密碼';

  @override
  String get shortcutGeneratePassword => '產生密碼';

  @override
  String get shortcutOpenUrl => '開啟 URL';

  @override
  String unexpectedError(String error) {
    return '不明錯誤：$error';
  }
}
