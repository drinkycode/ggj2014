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
	
	public var canInteract:Bool = true;
	public var interactionState:Int = -1;

	public var callOnce:Bool = true;
	public var called:Bool = false;
	
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
		setupSprite();
	}
	
	private function setupSprite():Void
	{
		
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	public function interact():Void
	{
		if (!canInteract) return;
		
		if (!callOnce || (callOnce && called))
		{
			called = true;
			doInteraction();
		}
	}
	
	private function doInteraction():Void
	{
		// Override this
	}
	
}