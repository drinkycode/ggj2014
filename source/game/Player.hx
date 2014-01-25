package game;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.input.keyboard.FlxKey;
import flixel.system.input.keyboard.FlxKeyboard;
import flixel.system.input.keyboard.FlxKeyShortcuts;

/**
 * ...
 * @author Michael Lee
 */
class Player extends FlxSpriteGroup
{

	public static inline var SPEED_X:Float = 384;
	public static inline var SPEED_Y:Float = 384;
	public static inline var MAX_VELOCITY_X:Float = 256;
	public static inline var MAX_VELOCITY_Y:Float = 256;
	public static inline var DRAG_X:Float = 2048;
	public static inline var DRAG_Y:Float = 2048;
	
	public var orientation:Int;
	
	public var interactionZone:FlxSprite; // Area for active interaction
	
	public var _sprite:FlxSprite;
	
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super();
		
		_sprite = new FlxSprite();
		_sprite.makeGraphic(48, 48, 0xffff00ff);
		_sprite.resetSize();
		_sprite.centerOffsets();
		_sprite.setOriginToCenter();
		
		interactionZone = new FlxSprite();
		interactionZone.makeGraphic(24, 24, 0xffffffff);
		interactionZone.resetSize();
		interactionZone.centerOffsets();
		interactionZone.setOriginToCenter();
		
		add(_sprite);
		add(interactionZone);
		
		reset(X, Y);
	}
	
	override public function destroy():Void 
	{
		_sprite = null;
		
		super.destroy();
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		
		maxVelocity.x = MAX_VELOCITY_X;
		maxVelocity.y = MAX_VELOCITY_Y;
		drag.x = DRAG_X;
		drag.y = DRAG_Y;
	}
	
	override public function update():Void 
	{
		acceleration.x = acceleration.y = 0; // Reset acceleration
		
		var updateOrientation:Bool = false;
		var newOrientation:Int = -1;
		
		if (FlxG.keyboard.anyPressed(["DOWN"]))
		{
			acceleration.y = SPEED_Y;
			updateOrientation = true;
			newOrientation = 4;
		}
		else if (FlxG.keyboard.anyPressed(["UP"]))
		{
			acceleration.y = -SPEED_Y;
			updateOrientation = true;
			newOrientation = 0;
		}
		
		if (FlxG.keyboard.anyPressed(["LEFT"]))
		{
			acceleration.x = -SPEED_X;
			updateOrientation = true;
			if (newOrientation == 4) orientation = 5;
			else if (newOrientation == 0) orientation = 7;
			else newOrientation = 6;
		}
		else if (FlxG.keyboard.anyPressed(["RIGHT"]))
		{
			acceleration.x = SPEED_X;
			updateOrientation = true;
			if (newOrientation == 4) orientation = 3;
			else if (newOrientation == 0) orientation = 1;
			else newOrientation = 2;
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
				ix = 0;
				iy = -16;
			case 1:
				ix = 16;
				iy = -16;
			case 2:
				ix = 16;
				iy = 0;
			case 3:
				ix = 16;
				iy = 16;
			case 4:
				ix = 0;
				iy = 16;
			case 5:
				ix = -16;
				iy = 16;
			case 6:
				ix = -16;
				iy = 0;
			case 7:
				ix = -16;
				iy = -16;
		}
		
		super.update();
		
		interactionZone.x = _sprite.x + ix;
		interactionZone.y = _sprite.y + iy;
	}
	
}