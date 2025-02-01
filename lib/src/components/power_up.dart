import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../brick_breaker.dart';
import '../config.dart';
import 'ball.dart';
import 'bat.dart';
import 'unbreakable_brick.dart';

enum PowerUpType { expandBat, shrinkBat, doubleBall, unbreakableBrick }

class PowerUp extends CircleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  PowerUp({
    required Vector2 position,
    required this.type,
  }) : super(
          position: position,
          radius: 10,
          anchor: Anchor.center,
          paint: Paint()
            ..color = _getColorForType(type)
            ..style = PaintingStyle.fill,
          children: [CircleHitbox()],
        );

  final PowerUpType type;

  static Color _getColorForType(PowerUpType type) {
    switch (type) {
      case PowerUpType.expandBat:
        return Colors.green;
      case PowerUpType.shrinkBat:
        return Colors.red;
      case PowerUpType.doubleBall:
        return Colors.blue;
      case PowerUpType.unbreakableBrick:
        return Colors.grey.shade800;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += 100 * dt; // Speed of falling power-up

    if (position.y > game.height) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bat) {
      activatePowerUp();
      removeFromParent();
    }
  }

  void activatePowerUp() {
    switch (type) {
      case PowerUpType.expandBat:
        _expandBat();
        break;
      case PowerUpType.shrinkBat:
        _shrinkBat();
        break;
      case PowerUpType.doubleBall:
        _doubleBall();
        break;
      case PowerUpType.unbreakableBrick:
        _spawnUnbreakableBrick();
        break;
    }
  }

  void _expandBat() {
    final bat = game.world.children.query<Bat>().first;
    bat.size.x *= 1.5;
    Future.delayed(const Duration(seconds: 10), () {
      if (!bat.isRemoved) {
        bat.size.x /= 1.5;
      }
    });
  }

  void _shrinkBat() {
    final bat = game.world.children.query<Bat>().first;
    bat.size.x *= 0.5;
    Future.delayed(const Duration(seconds: 10), () {
      if (!bat.isRemoved) {
        bat.size.x *= 2;
      }
    });
  }

  void _doubleBall() {
    final balls = game.world.children.query<Ball>();
    for (final ball in balls) {
      final newBall = Ball(
        velocity: ball.velocity.clone()..rotate(0.5),
        position: ball.position.clone(),
        radius: ball.radius,
        difficultyModifier: ball.difficultyModifier,
        color: ball.paint.color,
      );
      game.world.add(newBall);
    }
  }

  void _spawnUnbreakableBrick() {
    final random = math.Random();
    final x = random.nextDouble() * (game.width - brickWidth);
    final y = random.nextDouble() * (game.height * 0.5) + (game.height * 0.1);

    game.world.add(
      UnbreakableBrick(
        position: Vector2(x, y),
      ),
    );
  }
}
