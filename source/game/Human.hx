package game;

import flash.display.Sprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * Human characters
 * 
 * @author Michael Lee
 */
class Human extends FlxGroup
{

	public var sprite:FlxSprite;
	
	public var waypoints:Array<FlxObject>;
	public var currentWaypoint:FlxObject;
	
	private var _waypointIndex:Int = 0;
	
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super();
		
		sprite = new FlxSprite();
		sprite.makeGraphic(32, 74, 0xfff3c487);
		
		waypoints = new Array<FlxObject>();
		
		add(sprite);
		
		reset(X, Y);
	}
	
	override public function destroy():Void
	{
		sprite = null;
		waypoints = null;
		currentWaypoint = null;
		super.destroy();
	}
	
	public function reset(X:Float = 0, Y:Float = 0):Void
	{
		sprite.x = X;
		sprite.y = Y;
	}
	
	public function addWaypoint(X:Float, Y:Float):Void
	{
		var o:FlxObject = new FlxObject(X, Y, 4, 4);
		o.moves = false;
		o.active = false;
		
		waypoints.push(o);
		#if debug
		add(o);
		#end
	}
	
	public function move(Index:Int = 0):Void
	{
		_waypointIndex = Index;
		currentWaypoint = waypoints[_waypointIndex];
	}
	
	override public function update():Void
	{
		super.update();
		
		if (currentWaypoint != null)
		{
			//sprite
		}
	}
	
}