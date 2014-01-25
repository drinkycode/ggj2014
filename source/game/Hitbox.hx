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

	public static function create(X:Float, Y:Float, Width:Int, Height:Int):Void
	{
		var h:Hitbox = new Hitbox(X, Y, Width, Height);
		G.playstate.hitboxes.add(h);
		h.resetHitbox(X, Y, Width, Height);
		return h;
	}
	
	public function new(X:Float, Y:Float, Width:Int, Height:Int) 
	{
		super();
		
		//active = false;
		moves = false;
	}
	
	public function resetHitbox(X:Float, Y:Float, Width:Int, Height:Int):Void
	{
		reset(X, Y);
		setSize(Width, Height);
	}
	
}