// lib/src/components/brick.dart

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../brick_breaker.dart';
import '../config.dart';
import 'ball.dart';
import 'bat.dart';
import 'power_up.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Brick({required super.position, required Color color})
      : hitPoints =
            math.Random().nextInt(3) + 1, // Random hit points from 1 to 5
        super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          children: [RectangleHitbox()],
        );

  int hitPoints;
  late TextComponent hitText;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    hitText = TextComponent(
      text: '$hitPoints',
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
    add(hitText);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Ball) {
      hitPoints--;

      if (hitPoints <= 0) {
        if (math.Random().nextDouble() < 0.3) {
          // 30% chance to spawn power-up
          final powerUpType = PowerUpType
              .values[math.Random().nextInt(PowerUpType.values.length)];
          game.world
              .add(PowerUp(position: position.clone(), type: powerUpType));
        }

        removeFromParent();
        game.score.value++;

        if (game.world.children.query<Brick>().length == 1) {
          game.playState = PlayState.won;
          game.world.removeAll(game.world.children.query<Ball>());
          game.world.removeAll(game.world.children.query<Bat>());
        }
      } else {
        hitText.text = '$hitPoints'; // Update text to show remaining hits
      }
    }
  }
}
