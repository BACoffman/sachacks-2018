package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flash.system.System;

class MenuState extends FlxState {
	override public function create():Void {
		// Music
		FlxG.sound.playMusic(AssetPaths.plasma__ogg, 0.5, true);

		// Background
		FlxG.cameras.bgColor = FlxColor.WHITE;

		// Play Button
		var btnPlay:FlxButton;
		btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		add(btnPlay);
		btnPlay.screenCenter();

		/* Alternate: Press any button to play
			var playText:FlxText = new FlxText(0, 120, FlxG.width, "Press Any Button To Play");
			playText.setFormat(null, 24, FlxColor.WHITE);
			playText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
			playText.alignment = "center";
			playText.size = 32;
			add(playText);
		 */

		// Title Text
		var titleFormat = new FlxTextFormat(0xE6E600, true, false, 0xFF8000);
		var titleText:FlxText = new FlxText(0, 60, FlxG.width, "Rocket Combat");
		titleText.setFormat(null, 24, FlxColor.BLACK);
		titleText.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);
		titleText.alignment = "center";
		titleText.size = 64;
		titleText.addFormat(titleFormat, 0, 100);
		add(titleText);

		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	function clickPlay():Void {
		FlxG.switchState(new PlayState());
	}

	function createText(y:Float, ?text:String) {
		var text = new FlxText(60, y, FlxG.width, text);
		text.setFormat(null, 24, FlxColor.BLACK);
		text.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);
		return text;
	}
}
