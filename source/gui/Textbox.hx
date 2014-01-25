package gui;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

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
		
		text = new FlxText(0, 480, FlxG.width, "");
		text.setFormat(null, 16, 0xffffff, "center");
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
		_timer = 5;
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