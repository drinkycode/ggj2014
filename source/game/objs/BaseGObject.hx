package game.objs;

import flixel.FlxG;
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
	public var preInteractionMessage:String = "";
	public var postInteractionMessage:String = "";

	public var callOnce:Bool = false;
	public var called:Bool = false;
	public var calledTimes:Int = 0;
	public var requiredCalls:Int = 1;
	
	public var childObjName:String = "";
	public var childObject:BaseGObject;
	
	private var _cooldown:Float = 0;
	
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
		preInteractionMessage = null;
		postInteractionMessage = null;
		
		childObjName = null;
		childObject = null;
		super.destroy();
	}
	
	override public function update():Void 
	{
		super.update();
		_cooldown -= FlxG.elapsed;
	}
	
	public function interact(Force:Bool = false):Void
	{
		if (!Force && !canInteract) return;
		
		if (!callOnce || (callOnce && !called))
		{
			if (_cooldown <= 0)
			{
				called = true;
				calledTimes++;
				
				if (calledTimes == requiredCalls)
				{
					doInteraction();
					if (childObject != null)
					{
						childObject.interact(true);
					}
				}
				else if (calledTimes < requiredCalls)
				{
					doPreInteraction();
				}
				else
				{
					doPostInteraction();
				}
				
				_cooldown = 3;
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
	
	private function doPreInteraction():Void
	{
		if (preInteractionMessage != "")
		{
			G.playstate.gui.callTextbox(preInteractionMessage);
		}
	}
	
	private function doPostInteraction():Void
	{
		if (postInteractionMessage != "")
		{
			G.playstate.gui.callTextbox(postInteractionMessage);
		}
	}
	
}