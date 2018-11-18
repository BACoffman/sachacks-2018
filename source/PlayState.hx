package;

import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class PlayState extends FlxState {
	public static var rockets:FlxTypedGroup<Rocket>;

	public var player1:Player;
	public var player2:Player;
	public var floor:FlxSprite;

	override public function create():Void {
		// Remove cursor
		FlxG.mouse.visible = false;

		// Level
		floor = new FlxSprite(0, 300);
		floor.makeGraphic(640, 60, FlxColor.PINK);
		floor.immovable = true;
		add(floor);

		// Players
		player1 = new Player(100, 0, true);
		player2 = new Player(500, 0, false);
		add(player1);
		add(player2);

		rockets = new FlxTypedGroup<Rocket>(16);

		var rocket:Rocket;
		for (i in 0...16) {
			rocket = new Rocket(-100, -100);
			rocket.exists = false;

			rockets.add(rocket);
		}

		add(rockets);

		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		// FlxG.camera.follow(player1);

		// Screen Wrapping
		FlxSpriteUtil.screenWrap(player1, true, true, false, false);
		FlxSpriteUtil.screenWrap(player2, true, true, false, false);

		// Collisions
		FlxG.collide(player1, player2);
		FlxG.collide(floor, player1);
		FlxG.collide(floor, player2);

		// Hit player
		FlxG.overlap(player1, rockets, endGame);
		FlxG.overlap(player2, rockets, endGame);

		// Hit environment
		FlxG.overlap(floor, rockets, killRocket);
	}

	private function endGame(player:Player, rocket:Rocket) {
		player.health--;
		rocket.kill();
	}

	private function killRocket(floor:FlxSprite, rocket:Rocket) {
		rocket.kill();
	}
}
