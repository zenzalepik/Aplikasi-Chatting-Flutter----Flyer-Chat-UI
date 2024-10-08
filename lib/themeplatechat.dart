DefaultChatTheme DefaultChatTheme({
  Widget? attachmentButtonIcon,
  EdgeInsets? attachmentButtonMargin,
  Color backgroundColor = neutral7,
  EdgeInsetsGeometry? bubbleMargin,
  EdgeInsets dateDividerMargin = const EdgeInsets.only(bottom: 32, top: 16),
  TextStyle dateDividerTextStyle = const TextStyle(color: neutral2, fontSize: 12, fontWeight: FontWeight.w800, height: 1.333),
  Widget? deliveredIcon,
  Widget? documentIcon,
  TextStyle emptyChatPlaceholderTextStyle = const TextStyle(color: neutral2, fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
  Color errorColor = error,
  Widget? errorIcon,
  Color inputBackgroundColor = neutral0,
  Color inputSurfaceTintColor = neutral0,
  double inputElevation = 0,
  BorderRadius inputBorderRadius = const BorderRadius.vertical(top: Radius.circular(20)),
  Decoration? inputContainerDecoration,
  EdgeInsets inputMargin = EdgeInsets.zero,
  EdgeInsets inputPadding = const EdgeInsets.fromLTRB(24, 20, 24, 20),
  Color inputTextColor = neutral7,
  Color? inputTextCursorColor,
  InputDecoration inputTextDecoration = const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero, isCollapsed: true),
  TextStyle inputTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
  double messageBorderRadius = 20,
  double messageInsetsHorizontal = 20,
  double messageInsetsVertical = 16,
  double messageMaxWidth = 440,
  Color primaryColor = primary,
  TextStyle receivedEmojiMessageTextStyle = const TextStyle(fontSize: 40),
  TextStyle? receivedMessageBodyBoldTextStyle,
  TextStyle? receivedMessageBodyCodeTextStyle,
  TextStyle? receivedMessageBodyLinkTextStyle,
  TextStyle receivedMessageBodyTextStyle = const TextStyle(color: neutral0, fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
  TextStyle receivedMessageCaptionTextStyle = const TextStyle(color: neutral2, fontSize: 12, fontWeight: FontWeight.w500, height: 1.333),
  Color receivedMessageDocumentIconColor = primary,
  TextStyle receivedMessageLinkDescriptionTextStyle = const TextStyle(color: neutral0, fontSize: 14, fontWeight: FontWeight.w400, height: 1.428),
  TextStyle receivedMessageLinkTitleTextStyle = const TextStyle(color: neutral0, fontSize: 16, fontWeight: FontWeight.w800, height: 1.375),
  Color secondaryColor = secondary,
  Widget? seenIcon,
  Widget? sendButtonIcon,
  EdgeInsets? sendButtonMargin,
  Widget? sendingIcon,
  TextStyle sentEmojiMessageTextStyle = const TextStyle(fontSize: 40),
  TextStyle? sentMessageBodyBoldTextStyle,
  TextStyle? sentMessageBodyCodeTextStyle,
  TextStyle? sentMessageBodyLinkTextStyle,
  TextStyle sentMessageBodyTextStyle = const TextStyle(color: neutral7, fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
  TextStyle sentMessageCaptionTextStyle = const TextStyle(color: neutral7WithOpacity, fontSize: 12, fontWeight: FontWeight.w500, height: 1.333),
  Color sentMessageDocumentIconColor = neutral7,
  TextStyle sentMessageLinkDescriptionTextStyle = const TextStyle(color: neutral7, fontSize: 14, fontWeight: FontWeight.w400, height: 1.428),
  TextStyle sentMessageLinkTitleTextStyle = const TextStyle(color: neutral7, fontSize: 16, fontWeight: FontWeight.w800, height: 1.375),
  EdgeInsets statusIconPadding = const EdgeInsets.symmetric(horizontal: 4),
  SystemMessageTheme systemMessageTheme = const SystemMessageTheme(margin: EdgeInsets.only(bottom: 24, top: 8, left: 8, right: 8), textStyle: TextStyle(color: neutral2, fontSize: 12, fontWeight: FontWeight.w800, height: 1.333)),
  TypingIndicatorTheme typingIndicatorTheme = const TypingIndicatorTheme(animatedCirclesColor: neutral1, animatedCircleSize: 5.0, bubbleBorder: BorderRadius.all(Radius.circular(27.0)), bubbleColor: neutral7, countAvatarColor: primary, countTextColor: secondary, multipleUserTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: neutral2)),
  UnreadHeaderTheme unreadHeaderTheme = const UnreadHeaderTheme(color: secondary, textStyle: TextStyle(color: neutral2, fontSize: 12, fontWeight: FontWeight.w500, height: 1.333)),
  Color userAvatarImageBackgroundColor = Colors.transparent,
  List<Color> userAvatarNameColors = colors,
  TextStyle userAvatarTextStyle = const TextStyle(color: neutral7, fontSize: 12, fontWeight: FontWeight.w800, height: 1.333),
  TextStyle userNameTextStyle = const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, height: 1.333),
  Color? highlightMessageColor,
})