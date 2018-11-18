package;

import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.FlxG;
import flixel.FlxObject;

class Rocket extends FlxSprite {
	private var collideMap:FlxTilemap;

	override public function new(X:Int, Y:Int, map:FlxTilemap):Void {
		super(X, Y);

		// Graphics
		loadGraphic(AssetPaths.rocket__png, false, 11, 20);
		set_flipY(true);

		collideMap = map;
	}

	override public function update(elapsed:Float):Void {
		if (!alive) {
			exists = false;
		} else if (getScreenPosition().x < -16 || getScreenPosition().x > FlxG.width + 16 || getScreenPosition().y > FlxG.camera.y + 376 || touching != 0) {
			kill();
		} else if (collideMap.overlaps(this)) {
			kill();
		}

		y += 10;
		super.update(elapsed);
	}
}
