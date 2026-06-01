import 'package:cached_network_image/cached_network_image.dart';
import 'package:dlchat/src/core/common/selection_transformer.dart';
import 'package:dlchat/src/core/common/web_utils.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/chat/bloc/chat/chat_bloc.dart';
import 'package:dlchat/src/feature/chat/model/link.dart';
import 'package:dlchat/src/feature/chat/model/message.dart';
import 'package:dlchat/src/feature/chats/bloc/chats/chats_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/remaining/remaining_bloc.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_tonal_button.dart';
import 'package:dlchat/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class const ChatMessage({
  required final Message message,
  required final String chatId,
  required final List<String> savedImages,
  required final Future<void> Function(BuildContext context, String id, String link) saveImage,
  required final List<String> reportMessages,
  required final Future<void> Function(BuildContext context, String id) reportMessage,
  required final VoidCallback scrollToStart,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (message.type == MessageType.user || message.type == MessageType.image) {
      return Column(
        children: [
          _MessageDecoration(
            right: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(message.text),
                if (message.file != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          Material(
                            color: AppColors.iconFourth,
                            shape: const CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                Assets.svg.fileDocument.path,
                                height: 28,
                                width: 28,
                                colorFilter: const ColorFilter.mode(AppColors.iconSecondary, BlendMode.srcIn),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              message.file!,
                              style: AppTypography.bodyRegular.copyWith(color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 16,
            children: [
              _MessageActionButton(
                icon: Icons.content_copy,
                label: 'Копировать',
                onPressed: () async => await _copyText(context, message.text),
              ),
              if (message.type == MessageType.image)
                _MessageActionButton(
                  icon: Icons.repeat,
                  label: 'Повторить',
                  onPressed: () {
                    context.read<ChatBloc>().add(ChatEvent.sendMessage(text: message.text, isSearch: false));
                    context.read<ChatsBloc>().add(ChatsEvent.moveToTop(chatId));
                    context.read<RemainingBloc>().add(const RemainingEvent.decreaseImageRemaining());
                  },
                ),
            ],
          ),
        ],
      );
    }
    if (message.type == MessageType.imageAssistant) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ImageAssistantWidget(
            imageUrl: message.text,
            saveImage: (context, link) async => await saveImage.call(context, message.id, link),
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 16,
            children: [
              _MessageActionButton(
                icon: savedImages.contains(message.id) ? Icons.check : Icons.file_download_outlined,
                label: savedImages.contains(message.id) ? 'Сохранено' : 'Сохранить (доступно 24 часа)',
                onPressed: () async {
                  final String processedLink = kIsWeb ? WebUtils.proxyWebLink(context, message.text) : message.text;
                  await saveImage.call(context, message.id, processedLink);
                },
              ),
              if (reportMessages.contains(message.id))
                const _MessageActionButton(icon: Icons.warning_amber, label: 'Жалоба принята', onPressed: null)
              else
                _MessageActionButton(
                  icon: Icons.warning_amber,
                  label: 'Пожаловаться',
                  onPressed: () async => await reportMessage(context, message.id),
                ),
            ],
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.links.isNotEmpty)
          Material(
            borderRadius: BorderRadius.circular(50),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () async {
                await showCustomModalBottomSheet<void>(
                  context: context,
                  builder: (context) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ссылки:', style: AppTypography.bodySemibold),
                      const SizedBox(height: 8),
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: message.links.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () async => await launchUrl(Uri.parse(message.links[index].url)),
                          child: Text('${index + 1}. ${message.links[index].title}', style: AppTypography.bodyRegular),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  'Выполнен поиск на ${message.links.length} сайтах',
                  style: AppTypography.bodyRegular.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            onLongPress: () async => await _copyText(context, message.text),
            child: _AnimatedText(
              text: _processTextWithLinks(message),
              isNew: message.isNew,
              scrollToStart: scrollToStart,
            ),
          ),
        ),
        Row(
          children: [
            _MessageActionButton(
              icon: Icons.content_copy,
              label: 'Копировать',
              onPressed: () async => await _copyText(context, message.text),
            ),
            if (reportMessages.contains(message.id))
              _MessageActionButton(icon: Icons.warning_amber, label: 'Жалоба принята', onPressed: () {})
            else
              _MessageActionButton(
                icon: Icons.warning_amber,
                label: 'Пожаловаться',
                onPressed: () async => await reportMessage(context, message.id),
              ),
          ],
        ),
      ],
    );
  }

  String _processTextWithLinks(Message message) {
    // If there are no links, return the original text
    if (message.links.isEmpty) {
      return message.text;
    }

    // Otherwise, we'll process the text to ensure links are properly formatted for markdown
    String processedText = message.text;

    // Look for link references like [1], [2], etc. and replace them with markdown links
    for (var i = 0; i < message.links.length; i++) {
      final Link link = message.links[i];
      final linkRef = '[${i + 1}]';

      // Replace the reference with a markdown link
      processedText = processedText.replaceAll(linkRef, '[$linkRef](${link.url})');
    }

    return processedText;
  }

  Future<void> _copyText(BuildContext context, String text) => Clipboard.setData(ClipboardData(text: text)).then((_) {
    if (context.mounted) {
      showInfoMessage(context, 'Скопировано');
    }
  });
}

class const _MessageDecoration({required final Widget child, required final bool right}) extends StatefulWidget {
  @override
  State<_MessageDecoration> createState() => _MessageDecorationState();
}

class _MessageDecorationState() extends State<_MessageDecoration> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.right ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.6),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), child: widget.child),
          ),
        ),
      ],
    );
  }
}

class const _MessageActionButton({
  required final IconData icon,
  required final String label,
  required final VoidCallback? onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2)),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          Text(label, style: AppTypography.bodyRegular.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class const _ImageAssistantWidget({
  required final String imageUrl,
  required final Future<void> Function(BuildContext context, String link) saveImage,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String processedLink = kIsWeb ? WebUtils.proxyWebLink(context, imageUrl) : imageUrl;
    return Hero(
      tag: imageUrl,
      child: CachedNetworkImage(
        width: 300,
        height: 300,
        imageUrl: processedLink,
        imageBuilder: (context, imageProvider) => GestureDetector(
          onTap: () async => await showDialog<void>(
            context: context,
            builder: (context) => Dialog.fullscreen(
              child: _ImageFullScreen(imageUrl: imageUrl, imageProvider: imageProvider, saveImage: saveImage),
            ),
          ),
          child: SizedBox(
            width: 300,
            height: 300,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        placeholder: (context, url) => Shimmer(
          child: ShimmerLoading(
            inProgress: true,
            child: SizedBox(
              height: 300,
              width: 300,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error),
              Text('Изображение больше не доступно', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class const _ImageFullScreen({
  required final String imageUrl,
  required final ImageProvider imageProvider,
  required final Future<void> Function(BuildContext context, String link) saveImage,
}) extends StatefulWidget {
  @override
  State<_ImageFullScreen> createState() => _ImageFullScreenState();
}

class _ImageFullScreenState() extends State<_ImageFullScreen> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        InteractiveViewer(
          minScale: 0.5,
          child: Center(
            child: Hero(
              tag: widget.imageUrl,
              child: Image(image: widget.imageProvider, fit: BoxFit.contain),
            ),
          ),
        ),
        const Positioned(top: 8, right: 8, child: CustomCloseButton()),
        Positioned(
          bottom: 16,
          right: 0,
          left: 0,
          child: Center(
            child: SizedBox(
              width: 250,
              child: CustomFilledTonalButton(
                leadingIcon: _isSaved ? const Icon(Icons.check) : const Icon(Icons.save_alt),
                text: _isSaved ? 'Сохранено' : 'Сохранить',
                onPressed: _isSaved
                    ? null
                    : () async {
                        final String processedLink = kIsWeb
                            ? WebUtils.proxyWebLink(context, widget.imageUrl)
                            : widget.imageUrl;
                        await widget.saveImage(context, processedLink);
                        setState(() => _isSaved = true);
                      },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class const _AnimatedText({
  required final VoidCallback scrollToStart,
  required final String text,
  final bool isNew = false,
}) extends StatefulWidget {
  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState() extends State<_AnimatedText> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? _controller;
  late Animation<int> _animation;
  var _displayedText = '';

  @override
  void initState() {
    super.initState();
    if (widget.isNew) {
      _controller = AnimationController(
        duration: Duration(milliseconds: widget.text.length * 10),
        vsync: this,
      );
      if (_controller != null) {
        _animation = IntTween(begin: 0, end: widget.text.length).animate(_controller!)
          ..addListener(() {
            setState(() => _displayedText = widget.text.substring(0, _animation.value));
            widget.scrollToStart.call();
          });
        _controller?.forward();
      }
    } else {
      _displayedText = widget.text;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => widget.isNew;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SelectionArea(
      child: SelectionTransformer.separated(
        separator: '\n\n',
        child: MarkdownBody(
          data: _displayedText,
          styleSheet: MarkdownStyleSheet(
            h1: const TextStyle(fontWeight: FontWeight.bold),
            h2: const TextStyle(fontWeight: FontWeight.bold),
            h3: const TextStyle(fontWeight: FontWeight.bold),
            code: TextStyle(fontFamily: 'monospace', backgroundColor: Colors.grey[200]),
            horizontalRuleDecoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            a: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
          ),
          onTapLink: (text, href, title) async {
            if (href != null) {
              await launchUrl(Uri.parse(href));
            }
          },
        ),
      ),
    );
  }
}
