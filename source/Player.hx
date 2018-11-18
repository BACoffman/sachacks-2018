package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;

class Player extends FlxSprite {
	private var player1:Bool;
	private var rocketGroup:FlxTypedGroup<Rocket>;
	private var joy1:FlxGamepad;
	private var joy2:FlxGamepad;

	override public function new(X:Int, Y:Int, isPlayer1:Bool, rockets:FlxTypedGroup<Rocket>):Void {
		super(X, Y);

		player1 = isPlayer1;
		rocketGroup = rockets;

		health = 3;

		if (player1) {
			loadGraphic(AssetPaths.playerOne__png, true, 50, 50);
		} else {
			loadGraphic(AssetPaths.playerTwo__png, true, 50, 50);
		}

		width = 34;
		height = 46;

		offset.set(2, 4);

		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		animation.add("shoot", [10], 6, false);
		animation.add("lr", [0, 1, 2, 3, 4, 5, 6], 6, false);
		animation.add("idle", [8], 6, false);

		// max velocity and drag
		drag.set(1600, 1600);
		maxVelocity.set(250, 900);
		acceleration.y = 620;
	}

	override public function update(elapsed:Float):Void {
		joy1 = FlxG.gamepads.getByID(0);
		joy2 = FlxG.gamepads.getByID(1);

		FlxG.watch.addQuick("joy1 justPressed ID", joy1.firstJustPressedID());
		FlxG.watch.addQuick("joy2 justPressed ID", joy2.firstJustPressedID());

		movement(player1);
		shoot(player1);

		if (health <= 0) {
			// Game over
			kill();
		}

		super.update(elapsed);
	}

	private function movement(isPlayer1:Bool):Void {
		var left:Bool;
		var right:Bool;

		var leftJoy:Bool;
		var rightJoy:Bool;
		acceleration.x = 0;

		if (isPlayer1) {
			left = FlxG.keys.anyPressed([A]);
			right = FlxG.keys.anyPressed([D]);

			// JoyCon
			if (joy1 != null) {
				leftJoy = joy1.pressed.DPAD_LEFT;
				rightJoy = joy1.pressed.DPAD_RIGHT;
			}
		} else {
			left = FlxG.keys.anyPressed([J]);
			right = FlxG.keys.anyPressed([L]);

			// JoyCon
			if (joy2 != null) {
				leftJoy = joy2.pressed.DPAD_LEFT;
				rightJoy = joy2.pressed.DPAD_RIGHT;
			}
		}

		if (left || leftJoy) {
			acceleration.x = -drag.x;
			if (velocity.y == 0) {
				facing = FlxObject.LEFT;
				animation.play("lr");
			}
		} else if (right || rightJoy) {
			acceleration.x = drag.x;
			if (velocity.y == 0) {
				facing = FlxObject.RIGHT;
				animation.play("lr");
			}
		} else if (velocity.y == 0) {
			animation.play("idle");
		}
	}

	private function shoot(isPlayer1:Bool) {
		var shoot:Bool;
		var shootJoy:Bool;

		if (isPlayer1) {
			shoot = FlxG.keys.anyJustPressed([S]);
			if (joy1 != null) {
				// shootJoy = joy1.anyJustPressed()
			}
		} else {
			shoot = FlxG.keys.anyJustPressed([K]);
		}
		if (shoot) {
			var rocket:Rocket = rocketGroup.recycle();
			rocket.reset(x + (width - rocket.width) / 2, y + (height));
			rocket.solid = true;

			if (velocity.y == 0) {
				velocity.y = -0.6 * maxVelocity.y;
			}

			animation.play("shoot");
			FlxG.sound.play(AssetPaths.explode3__wav);
		}
	}
}
