package source.gui;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import util.GAssets;

/**
 * Popup textbox 
 * 
 * @author Michael Lee
 */
class TextPopup extends FlxSpriteGroup
{

	public var text:FlxText;
	
	private var _timer:Float = 0;
	
	public function new() 
	{
		super();
		
		text = new FlxText(-80, 0, 160, "");
		text.setFormat(GAssets.getFile("awesome",GAssets.LOC_DATA,"ttf"), 20, 0xffffff, "center", FlxText.BORDER_OUTLINE, 0x000000, true);
		add(text);
		
		hide();
	}
	
	override public function destroy():Void 
	{
		text = null;
		super.destroy();
	}
	
	public function show(X:Float, Y:Float, Message:String):Void
	{
		visible = true;
		
		text.text = Message;
		_timer = 7;
		
		x = X;
		y = Y;
	}
	
	public function hide():Void
	{
		visible = false;
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (!visible) return;
		
		_timer -= FlxG.elapsed;
		if (_timer <= 0)
		{
			hide();
		}
	}
	
}