package game.objs;

import flixel.FlxSprite;

/**
 * Base game object
 * 
 * @author Michael Lee
 */
class BaseGObject extends FlxSprite
{
	
	public var location:Int = 0;
	public var objName:String = "";
	
	public var canInteract:Bool = true;
	public var interactionState:Int = -1;
	
	public var interactionMessage:String = "";

	public var callOnce:Bool = true;
	public var called:Bool = false;
	
	public var childObjName:String = "";
	public var childObject:BaseGObject;
	
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
		setupSprite();
	}
	
	private function setupSprite():Void
	{
		
	}
	
	override public function destroy():Void 
	{
		objName = null;
		interactionMessage = null;
		childObjName = null;
		childObject = null;
		super.destroy();
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	public function interact(Force:Bool = false):Void
	{
		if (!Force && !canInteract) return;
		
		if (!callOnce || (callOnce && !called))
		{
			called = true;
			doInteraction();
			
			if (childObject != null)
			{
				childObject.interact(true);
			}
		}
	}
	
	private function doInteraction():Void
	{
		if (interactionMessage != "")
		{
			G.playstate.gui.callTextbox(interactionMessage);
		}
	}
	
}