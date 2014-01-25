package game.objs.misc;

import flixel.FlxSprite;
import game.objs.BaseGObject;

/**
 * Chew toy
 * 
 * @author Michael Lee
 */
class ChewToy extends BaseGObject
{

	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
	}
	
	override private function setupSprite():Void 
	{
		super.setupSprite();
		
		makeGraphic(20, 20, 0xffffffff);
		color = 0xff0000;
	}
	
	override private function doInteraction():Void 
	{
		color = 0x000000;
		
		G.playstate.gui.callTextbox("Object message goes here");
	}
	
}