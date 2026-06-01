import 'package:dlchat/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:flutter/material.dart';

class const ChatShimmer({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ShimmerLoading(
                  inProgress: true,
                  child: SizedBox(
                    height: 24,
                    width: 200,
                    child: DecoratedBox(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ShimmerLoading(
              inProgress: true,
              child: SizedBox(
                height: 140,
                width: 240,
                child: DecoratedBox(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16))),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ShimmerLoading(
                  inProgress: true,
                  child: SizedBox(
                    height: 24,
                    width: 200,
                    child: DecoratedBox(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ShimmerLoading(
              inProgress: true,
              child: SizedBox(
                height: 250,
                width: 250,
                child: DecoratedBox(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
