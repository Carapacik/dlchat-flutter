import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:dlchat/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:dlchat/src/feature/transcription/bloc/detail_transcription/detail_transcription_bloc.dart';
import 'package:dlchat/src/feature/transcription/model/transcription_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const DetailTranscriptionScreen({required final String name, super.key}) extends StatefulWidget {
  @override
  State<DetailTranscriptionScreen> createState() => _DetailTranscriptionScreenState();
}

class _DetailTranscriptionScreenState() extends State<DetailTranscriptionScreen> {
  late final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<DetailTranscriptionBloc>().add(const DetailTranscriptionEvent.fetch());
    }
  }

  bool get _isBottom {
    final DetailTranscriptionBloc bloc = context.read<DetailTranscriptionBloc>();
    if (!_scrollController.hasClients || bloc.state.hasReachedMax) {
      return false;
    }
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailTranscriptionBloc, DetailTranscriptionState>(
      listener: (context, state) {
        if (state case final DetailTranscriptionFailure s) {
          showCustomAppException(context, s.exception);
        }
      },
      child: Scaffold(
        appBar: buildPlatformAppBar(context, titleText: 'Анализ'),
        extendBodyBehindAppBar: true,
        body: ChatGradient(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(widget.name, style: AppTypography.headerMedium),
                  ),
                ),
                Shimmer(
                  child: BlocBuilder<DetailTranscriptionBloc, DetailTranscriptionState>(
                    builder: (context, state) {
                      if (state.inProgress) {
                        return Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.fromLTRB(16, 20, 16, 24 + MediaQuery.paddingOf(context).bottom),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              return const Column(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 4,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ShimmerLoading(inProgress: true, child: SizedBox(width: 40, height: 16)),
                                  ShimmerLoading(
                                    inProgress: true,
                                    borderRadius: BorderRadius.all(Radius.circular(24)),
                                    child: SizedBox(width: double.infinity, height: 200),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      }
                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async =>
                              context.read<DetailTranscriptionBloc>().add(const DetailTranscriptionEvent.start()),
                          child: ListView.separated(
                            padding: EdgeInsets.fromLTRB(16, 20, 16, 24 + MediaQuery.paddingOf(context).bottom),
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: state.messages.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final TranscriptionMessage message = state.messages[index];
                              return Column(
                                spacing: 4,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    index == 2
                                        ? 'Источник'
                                        : index == 1
                                        ? 'Транскрибация'
                                        : 'Анализ содержимого',
                                  ),
                                  _MessageItem(message: message),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class const _MessageItem({required final TranscriptionMessage message}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SelectableText(message.text, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
      ),
    );
  }
}
