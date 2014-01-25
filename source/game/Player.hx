package game;

import flixel.animation.FlxAnimationController;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.system.input.keyboard.FlxKey;
import flixel.system.input.keyboard.FlxKeyboard;
import flixel.system.input.keyboard.FlxKeyShortcuts;
import util.GAssets;

/**
 * Doggy doge
 * 
 * @author Michael Lee
 */
class Player extends FlxGroup
{

	public static inline var SPEED_X:Float = 272;
	public static inline var SPEED_Y:Float = 272;
	public static inline var MAX_VELOCITY_X:Float = 198;
	public static inline var MAX_VELOCITY_Y:Float = 198;
	public static inline var DRAG_X:Float = 2048;
	public static inline var DRAG_Y:Float = 2048;
	
	public var orientation:Int;
	
	public var interactionZone:FlxSprite; // Area for active interaction
	public var sprite:FlxSprite;
	
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super();
		
		sprite = new FlxSprite();
		
		sprite.loadGraphic(GAssets.getFile("player"), true, true, 64, 64);
		sprite.animation.add("idle", [0], 0, false);
		sprite.animation.play("idle");
		
		sprite.width = 48;
		sprite.height = 32;
		//_sprite.resetSize();
		//_sprite.resetSizeFromFrame();
		sprite.centerOffsets();
		sprite.offset.y += 4;
		//_sprite.setOriginToCenter();
		
		interactionZone = new FlxSprite();
		interactionZone.makeGraphic(24, 24, 0xffffffff);
		interactionZone.alpha = 0.5;
		//interactionZone.resetSize();
		//interactionZone.centerOffsets();
		//interactionZone.setOriginToCenter();
		interactionZone.moves = false;
		
		add(sprite);
		add(interactionZone);
		
		reset(X, Y);
	}
	
	override public function destroy():Void 
	{
		sprite = null;
		super.destroy();
	}
	
	public function reset(X:Float, Y:Float):Void 
	{
		sprite.x = X;
		sprite.y = Y;
		
		sprite.maxVelocity.x = MAX_VELOCITY_X;
		sprite.maxVelocity.y = MAX_VELOCITY_Y;
		sprite.drag.x = DRAG_X;
		sprite.drag.y = DRAG_Y;
	}
	
	override public function update():Void 
	{
		sprite.acceleration.x = sprite.acceleration.y = 0; // Reset acceleration
		
		var updateOrientation:Bool = false;
		var newOrientation:Int = -1;
		
		if (FlxG.keyboard.anyPressed(["DOWN"]))
		{
			sprite.acceleration.y = SPEED_Y;
			updateOrientation = true;
			newOrientation = 4;
		}
		else if (FlxG.keyboard.anyPressed(["UP"]))
		{
			sprite.acceleration.y = -SPEED_Y;
			updateOrientation = true;
			newOrientation = 0;
		}
		
		if (FlxG.keyboard.anyPressed(["LEFT"]))
		{
			sprite.acceleration.x = -SPEED_X;
			updateOrientation = true;
			newOrientation = 6;
			sprite.facing = FlxObject.LEFT;
		}
		else if (FlxG.keyboard.anyPressed(["RIGHT"]))
		{
			sprite.acceleration.x = SPEED_X;
			updateOrientation = true;
			newOrientation = 2;
			sprite.facing = FlxObject.RIGHT;
		}
		
		if (FlxG.keyboard.anyJustPressed(["X"]))
		{
			checkInteraction();
		}
		
		var ix:Float = 0;
		var iy:Float = 0;
		
		if (updateOrientation)
		{
			orientation = newOrientation;
		}
		
		switch (orientation) 
		{
			case 0:
				ix = 12;
				iy = -16;
			case 1:
				ix = 40;
				iy = -16;
			case 2:
				ix = 40;
				iy = 12;
			case 3:
				ix = 40;
				iy = 40;
			case 4:
				ix = 12;
				iy = 40;
			case 5:
				ix = -16;
				iy = 40;
			case 6:
				ix = -16;
				iy = 12;
			case 7:
				ix = -16;
				iy = -16;
		}
		
		interactionZone.x = sprite.x + ix;
		interactionZone.y = sprite.y + iy;
		
		super.update();
	}
	
	public function checkInteraction():Void
	{
		FlxG.overlap(interactionZone, G.playstate.gmap.gobjs, interactWithObject);
	}
	
	private function interactWithObject(P:Dynamic, Obj:Dynamic):Void
	{
		Reflect.callMethod(Obj, Reflect.field(Obj, "interact"), []);
	}
	
}