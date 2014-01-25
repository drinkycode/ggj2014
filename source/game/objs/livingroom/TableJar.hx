package game.objs.livingroom;

import game.objs.BaseGObject;

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
		canInteract = false;
	}
	
	override private function setupSprite():Void 
	{
		super.setupSprite();
		
		makeGraphic(10, 10, 0xffffffff);
		color = 0xff0000;
	}
	
	override private function doInteraction():Void 
	{
		super.doInteraction();
		color = 0x000000;
	}
	
}