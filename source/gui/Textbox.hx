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

	public static inline var DOG:Int = 0;
	public static inline var HUMAN:Int = 1;
	public var text:FlxText;
	
	private var _timer:Float = 0;
	
	public function new(type:Int = HUMAN) 
	{
		super();
		
		if(type == DOG) {
		text = new FlxText(0, 270, FlxG.width, "");
		text.setFormat(GAssets.getFile("awesome", GAssets.LOC_DATA, "ttf"), 24, 0xffffff, "center", FlxText.BORDER_OUTLINE, 0x000000, true);
		
		} else {
			
			text = new FlxText(0, 270, FlxG.width, "");
			text.setFormat(GAssets.getFile("HelvetiHand", GAssets.LOC_DATA, "ttf"), 24, 0xffffff, "center", FlxText.BORDER_OUTLINE, 0x000000, true);
		
		}
		
		
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