package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;

class Rocket extends FlxSprite {
	override public function new(X:Int, Y:Int):Void {
		super(X, Y);

		// Graphics
		makeGraphic(4, 8, FlxColor.LIME);
	}

	override public function update(elapsed:Float):Void {
		if (!alive) {
			exists = false;
		} else if (getScreenPosition().x < -16 || getScreenPosition().x > FlxG.width + 16 || getScreenPosition().y > FlxG.height + 16 || touching != 0) {
			kill();
		}

		y += 6;
		super.update(elapsed);
	}
}
