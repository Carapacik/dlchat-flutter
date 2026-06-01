import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';

class const CustomExpansionItem({
  required final VoidCallback onTap,
  required final bool? isExpanded,
  required final String title,
  required final Widget body,
  super.key,
}) extends StatefulWidget {
  @override
  State<CustomExpansionItem> createState() => _CustomExpansionItemState();
}

class _CustomExpansionItemState() extends State<CustomExpansionItem> {
  @override
  Widget build(BuildContext context) {
    final Widget expandIconPadded = ExpandIcon(
      color: AppColors.black800,
      disabledColor: AppColors.black800,
      isExpanded: widget.isExpanded ?? false,
      size: 20,
      padding: EdgeInsets.zero,
      onPressed: null,
    );
    final Widget header = Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: 24,
                child: Text(widget.title, style: AppTypography.bodySettingsMedium.copyWith(color: AppColors.black800)),
              ),
            ),
          ),
        ),
        if (widget.isExpanded != null) expandIconPadded,
      ],
    );
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(onTap: widget.onTap, borderRadius: BorderRadius.circular(8), child: header),
        ),
        AnimatedCrossFade(
          firstChild: const LimitedBox(maxWidth: 0, child: SizedBox(width: double.infinity, height: 0)),
          secondChild: widget.body,
          firstCurve: const Interval(0, 0.6, curve: Curves.fastOutSlowIn),
          secondCurve: const Interval(0.4, 1, curve: Curves.fastOutSlowIn),
          sizeCurve: Curves.fastOutSlowIn,
          crossFadeState: (widget.isExpanded ?? false) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 400),
        ),
      ],
    );
  }
}
