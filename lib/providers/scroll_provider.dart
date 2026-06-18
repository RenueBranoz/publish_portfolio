import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks overall page scroll progress as a 0.0-1.0 fraction, driving
/// the top scroll-progress indicator bar and the visibility of the
/// back-to-top floating button.
class ScrollProgressNotifier extends StateNotifier<double> {
  ScrollProgressNotifier() : super(0.0);

  void update(double offset, double maxExtent) {
    if (maxExtent <= 0) {
      state = 0.0;
      return;
    }
    state = (offset / maxExtent).clamp(0.0, 1.0);
  }
}

final scrollProgressProvider =
    StateNotifierProvider<ScrollProgressNotifier, double>(
        (ref) => ScrollProgressNotifier());

/// Tracks which section index is currently active/visible, used to
/// highlight the corresponding nav link.
final activeSectionProvider = StateProvider<int>((ref) => 0);
