package;

import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxAxes;

class PlayState extends FlxState {
	public var rockets:FlxTypedGroup<Rocket>;
	public var player1:Player;
	public var player2:Player;
	public var floor:FlxSprite;
	public var map:FlxOgmoLoader;
	public var mapCollisions:FlxTilemap;
	public var mapBG:FlxTilemap;
	public var cameraTarget:FlxObject;
	public var winText:FlxText;
	public var redoText:FlxText;

	private var gameOver:Bool;

	override public function create():Void {
		// Remove cursor
		FlxG.mouse.visible = false;

		// Game state
		gameOver = false;

		// Level
		map = new FlxOgmoLoader(AssetPaths.rocketMap__oel);
		mapBG = map.loadTilemap(AssetPaths.generic_platformer_tiles__png, 32, 32, "backdrop");
		mapCollisions = map.loadTilemap(AssetPaths.generic_platformer_tiles__png, 32, 32, "collisions");
		mapCollisions.allowCollisions = FlxObject.ANY;

		mapCollisions.follow();
		mapCollisions.allowCollisions = FlxObject.ANY;
		add(mapBG);
		add(mapCollisions);

		rockets = new FlxTypedGroup<Rocket>(16);

		// Players
		player1 = new Player(100, 2322, true, rockets);
		player2 = new Player(500, 2322, false, rockets);
		add(player1);
		add(player2);

		super.create();

		var rocket:Rocket;
		for (i in 0...16) {
			rocket = new Rocket(-100, -100, mapCollisions);
			rocket.exists = false;

			rockets.add(rocket);
		}

		add(rockets);

		// Camera
		cameraTarget = new FlxObject(0, 0, 0, 0);
		cameraTarget.y = player1.y;
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height);
		FlxG.worldBounds.set(0, 0, map.width, map.height);

		winText = new FlxText(0, 0, "Winner: ", 100);
		winText.alpha = 0;
		winText.alignment = "center";
		add(winText);

		redoText = new FlxText(0, 0, "Press SPACE to Play Again", 20);
		redoText.alpha = 0;
		redoText.color = FlxColor.WHITE;
		redoText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		redoText.alignment = "center";
		add(redoText);

		// Music
		FlxG.sound.playMusic(AssetPaths.overcome__ogg, 0.5, true);

		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		// Camera
		FlxG.camera.follow(cameraTarget);

		if (cameraTarget.y > 200) {
			cameraTarget.y -= 1;
		}

		winText.y = FlxG.camera.scroll.y + 50;
		redoText.y = FlxG.camera.scroll.y + 350;

		// Screen Wrapping
		FlxSpriteUtil.screenWrap(player1, true, true, false, false);
		FlxSpriteUtil.screenWrap(player2, true, true, false, false);

		// Collisions
		FlxG.collide(player1, player2);
		FlxG.collide(mapCollisions, player1);
		FlxG.collide(mapCollisions, player2);

		// Hit player
		FlxG.overlap(player1, rockets, endGame);
		FlxG.overlap(player2, rockets, endGame);

		// Hit environment
		FlxG.collide(mapCollisions, rockets, killRocket);

		// If player falls off map
		if (player1.y > cameraTarget.y + 200 && player1.exists && player2.alive && cameraTarget.y < 2300) {
			player1.kill();
		}

		if (player2.y > cameraTarget.y + 200 && player2.exists && player1.alive && cameraTarget.y < 2300) {
			player2.kill();
		}

		// Checks if dead
		if (!player1.alive && player2.alive) {
			FlxG.camera.follow(player2);
			winText.text = "WINNER:\nPlayer 2!";
			winText.color = FlxColor.GREEN;
			winText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
			winText.alpha = 1;
			winText.screenCenter(FlxAxes.X);

			redoText.alpha = 1;
			redoText.screenCenter(FlxAxes.X);

			gameOver = true;
		}

		if (!player2.alive && player1.alive) {
			FlxG.camera.follow(player1);
			winText.text = "WINNER:\nPlayer 1!";
			winText.color = FlxColor.RED;
			winText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
			winText.alpha = 1;
			winText.screenCenter(FlxAxes.X);

			redoText.alpha = 1;
			redoText.screenCenter(FlxAxes.X);

			gameOver = true;
		}

		if (FlxG.keys.anyJustPressed([SPACE]) && gameOver) {
			FlxG.switchState(new PlayState());
		}
	}

	private function endGame(player:Player, rocket:Rocket) {
		player.health--;
		rocket.kill();
	}

	private function killRocket(map:FlxTilemap, rocket:Rocket) {
		rocket.kill();
	}
}
