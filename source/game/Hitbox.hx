package game;

import flixel.FlxG;
import flixel.FlxObject;

/**
 * Basic collision box
 * 
 * @author Michael Lee
 */
class Hitbox extends FlxObject
{

	public static function create(X:Float, Y:Float, Width:Int, Height:Int):Hitbox
	{
		var h:Hitbox = new Hitbox(X, Y, Width, Height);
		h.resetHitbox(X, Y, Width, Height);
		return h;
	}
	
	public function new(X:Float, Y:Float, Width:Int, Height:Int) 
	{
		super();
		immovable = true;
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		//active = false;
		moves = false;
	}
	
	public function resetHitbox(X:Float, Y:Float, Width:Int, Height:Int):Void
	{
		reset(X, Y);
		setSize(Width, Height);
	}
	
}