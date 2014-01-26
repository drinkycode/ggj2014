package game.objs.livingroom;

import flixel.FlxSprite;
import flixel.animation.FlxAnimationController;
import game.objs.BaseGObject;
import util.GAssets;

/**
 * Books on top of coffee table
 * 
 * @author Michael Lee
 */
class Books extends BaseGObject
{
	
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y, "books", 64, 128, "grgrgrgrn", "no master");
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