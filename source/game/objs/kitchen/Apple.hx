package game.objs.kitchen;
import flixel.FlxSprite;
import flixel.animation.FlxAnimationController;
import game.objs.BaseGObject;
import util.GAssets;

/**
 * Jar on top of table
 * 
 * @author Michael Lee
 */
class Apple extends BaseGObject
{
	
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y, "apple", 64, 64, "food?", "i eat", false);
		canInteract = false;
		badInteraction = true;
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