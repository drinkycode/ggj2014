package gui;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import util.GAssets;

/**
 * Textbox
 * 
 * @author Michael Lee
 */
class Textbox extends FlxSpriteGroup
{

	public var text:FlxText;
	
	private var _timer:Float = 0;
	
	public function new() 
	{
		super();
		
		text = new FlxText(0, 280, FlxG.width, "");
		text.setFormat(GAssets.FNT_FONT, 16, 0xffffff, "center", FlxText.BORDER_NONE, 0x000000, true);
		add(text);
		
		scrollFactor.x = scrollFactor.y = 0;
		
		hide();
	}
	
	override public function destroy():Void 
	{
		text = null;
		super.destroy();
	}
	
	public function show(Message:String = ""):Void
	{
		visible = true;
		
		text.text = Message;
		_timer = 3;
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