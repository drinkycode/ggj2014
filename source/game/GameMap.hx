package game;

import flixel.group.FlxGroup;

/**
 * Controls the game map
 * 
 * @author Michael Lee
 */
class GameMap 
{

	public var floors:FlxGroup;
	public var baseFurniture:FlxGroup;
	public var gameObjects:FlxGroup;
	
	public function new() 
	{
		
	}
	
	public function destroy():Void
	{
		floors = null;
		baseFurniture = null;
		gameObjects = null;
	}
	
	public function update():Void
	{
		
	}
	
}