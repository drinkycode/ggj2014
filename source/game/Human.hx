package game;

import flixel.animation.FlxAnimationController;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.plugin.TweenManager;
import flixel.tweens.FlxTween;
import flixel.util.FlxMath;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import flixel.util.FlxVelocity;
import flixel.util.loaders.TexturePackerData;
import util.GAssets;

/**
 * Human characters
 * 
 * @author Michael Lee
 */
class Human extends FlxGroup
{

	public var allowInteraction:Bool = false;
	
	public var sprite:FlxSprite;
	
	public var waypoints:Array<FlxPoint>;
	public var currentWaypoint:FlxPoint;
	
	private var _waypointIndex:Int = 0;
	
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super();
		
		sprite = new FlxSprite();
		//sprite.makeGraphic(32, 74, 0xfff3c487);
		
		sprite.loadImageFromTexture(new TexturePackerData(GAssets.getFile("human", GAssets.LOC_IMGS, "json"), GAssets.getFile("human")), true, false, "human_base.png");
		sprite.animation.addByNames("idle", ["human_base.png"], 0, false);
		sprite.animation.addByNames("cry", ["human_cry.png"], 0, false);
		sprite.animation.addByNames("scold", ["human_scold.png"], 0, false);
		sprite.animation.addByNames("walk", ["human_walk1.png", "human_walk2.png"], 10, true);
		
		sprite.animation.play("idle");
		
		waypoints = new Array<FlxPoint>();
		
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
		var p:FlxPoint = new FlxPoint(X, Y);
		waypoints.push(p);
		
		#if debug
		var o:FlxObject = new FlxObject(X, Y, 4, 4);
		o.moves = false;
		o.active = false;
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
			FlxVelocity.moveTowardsPoint(sprite, currentWaypoint, 40);
			//trace(Math.abs(sprite.x + sprite.origin.x - currentWaypoint.x));
			if ((Math.abs(sprite.x + sprite.origin.x - currentWaypoint.x) < 2) && (Math.abs(sprite.y + sprite.origin.y - currentWaypoint.y) < 2))
			{
				_waypointIndex++;
				if (_waypointIndex < waypoints.length)
				{
					currentWaypoint = waypoints[_waypointIndex];
				}
				else
				{
					currentWaypoint = null;
					sprite.velocity.x = sprite.velocity.y = 0;
				}
			}
		}
	}
	
}