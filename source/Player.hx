package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;


class Player extends FlxSprite {
    private var player1:Bool;
    
    override public function new(X:Int, Y:Int, isPlayer1:Bool):Void {

        super(X, Y);

        player1 = isPlayer1;

        if(player1) {
            makeGraphic(16, 32, FlxColor.BLUE);
        } else {
            makeGraphic(16, 32, FlxColor.RED);
        }

        //max velocity and drag
        drag.set(720, 720);
        maxVelocity.set(90, 250);
        acceleration.y = 620;
    }

    override public function update(elapsed:Float):Void {
        
        movement(player1);
        jump(player1);

        super.update(elapsed);
	}

    private function movement(isPlayer1:Bool):Void {
        var left:Bool;
        var right:Bool;
        acceleration.x = 0;

        if(isPlayer1){
            left = FlxG.keys.anyPressed([A]);
            right = FlxG.keys.anyPressed([D]);
        } else {
            left = FlxG.keys.anyPressed([J]);
            right = FlxG.keys.anyPressed([L]);
        }

        if(left){
            acceleration.x = -drag.x;
        } else if(right) {
            acceleration.x = drag.x;
        }
    }

    private function jump(isPlayer1:Bool) {
        var jump:Bool;
        if(isPlayer1) {
            jump = FlxG.keys.anyJustPressed([W]);
        } else {
            jump = FlxG.keys.anyJustPressed([I]);
        }

        if(velocity.y == 0 && jump) {
            velocity.y = -0.6 * maxVelocity.y;
        }
    }
}