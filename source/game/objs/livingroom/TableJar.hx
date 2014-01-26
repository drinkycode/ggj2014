package game.objs.livingroom;

import flixel.FlxSprite;
import flixel.animation.FlxAnimationController;
import game.objs.BaseGObject;
import util.GAssets;

/**
 * Jar on top of table
 * 
 * @author Michael Lee
 */
class TableJar extends BaseGObject
{
	
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
		objName = "table_jar";
		interactionMessage = "Broke jar";
		postInteractionMessage = "thing broke master upset";
		canInteract = false;
	}
	
	override private function setupSprite():Void 
	{
		super.setupSprite();
		
		loadGraphic(GAssets.getFile("flower_vase"), true, false, 64, 128);
		animation.add("idle", [0], 0, false);
		animation.add("broken", [1], 0, false);
		
		animation.play("idle");
	}
	
	override private function doInteraction():Void 
	{
		super.doInteraction();
		animation.play("broken");
	}
	
}