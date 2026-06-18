import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

/// Tracks global pointer position for the mouse-follow glow effect
/// requested in the "Extra Premium Features" section.
/// Updated by a MouseRegion in the root scaffold (web/desktop only --
/// on touch devices this simply stays at its last/default position).
class PointerPositionNotifier extends StateNotifier<Offset> {
  PointerPositionNotifier() : super(Offset.zero);

  void update(Offset position) => state = position;
}

final pointerPositionProvider =
    StateNotifierProvider<PointerPositionNotifier, Offset>(
        (ref) => PointerPositionNotifier());
