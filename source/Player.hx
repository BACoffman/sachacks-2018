package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;


class Player extends FlxSprite {
    private var player1:Bool;
    
    override public function new(X:Int, Y:Int, isPlayer1:Bool):Void {

        super(X, Y);

        player1 = isPlayer1;

        if(player1) {
            loadGraphic(AssetPaths.playerOne__png, true, 50, 50);
        } else {
            loadGraphic(AssetPaths.playerTwo__png, true, 50, 50);
        }

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);
        animation.add("shoot", [10], 6, false);
        animation.add("lr", [0, 1, 2, 3 ,4, 5, 6], 6, false);
        animation.add("idle", [8], 6, false);

        //max velocity and drag
        drag.set(1600, 1600);
        maxVelocity.set(250, 700);
        acceleration.y = 620;
    }

    override public function update(elapsed:Float):Void {
        
        movement(player1);
        shoot(player1);

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
            if(velocity.y == 0){
                facing = FlxObject.LEFT;
                animation.play("lr");
            }
        } else if(right) {
            acceleration.x = drag.x;
            if(velocity.y == 0){
                facing = FlxObject.RIGHT;
                animation.play("lr");
            }
        } else if(velocity.y == 0) {
            animation.play("idle");
        }
    }

    private function shoot(isPlayer1:Bool){
        var shoot:Bool;
        if(isPlayer1){
            shoot = FlxG.keys.anyJustPressed([S]);
        } else {
            shoot = FlxG.keys.anyJustPressed([K]);
        }
        if(shoot){
            var rocket:Rocket = PlayState.rockets.recycle();
            rocket.reset(x + (width - rocket.width) / 2, y + (height));

            if(velocity.y == 0){
                velocity.y = -0.6 * maxVelocity.y;
            }

            animation.play("shoot");
        }
    }
}