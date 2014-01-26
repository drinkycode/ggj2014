package game.objs;

import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * Single game event
 * 
 * @author Michael Lee
 */
class GameTextArea extends FlxObject
{

	public var triggered:Bool = false;
	public var message:String = "";
	
	public function new(X:Float = 0, Y:Float = 0, Width:Int = 0, Height:Int = 0, Message:String = "") 
	{
		super(X, Y, Width, Height);
		message = Message;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	public function trigger():Void
	{
		if (triggered) return;
		
		triggered = true;
		if (message != "")
		{
			G.playstate.gui.callTextbox(message);
		}
	}
	
}