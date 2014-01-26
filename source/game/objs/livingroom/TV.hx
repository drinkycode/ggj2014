package game.objs.livingroom;

import flixel.FlxSprite;
import flixel.animation.FlxAnimationController;
import game.objs.BaseGObject;
import util.GAssets;

/**
 * tv on top of tv table
 * 
 * @author Michael Lee
 */
class TV extends BaseGObject
{
	
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y, "tv", 100, 100, "people in here", "master not here");
		canInteract = false;
	}
	
	override private function setupSprite():Void 
	{
		super.setupSprite();
	}
	
	override private function doInteraction():Void 
	{
		super.doInteraction();
	}
	
}