// lib/src/components/unbreakable_brick.dart

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../brick_breaker.dart';
import '../config.dart';

class UnbreakableBrick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  UnbreakableBrick({required super.position})
      : super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          paint: Paint()
            ..color = Colors.grey.shade800
            ..style = PaintingStyle.fill,
          children: [RectangleHitbox()],
        );
}
