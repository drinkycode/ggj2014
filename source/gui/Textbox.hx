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
	
	public function new() 
	{
		super();
		
		text = new FlxText(0, 480, FlxG.width, "Only dog knows");
		text.setFormat(null, 16, 0xffffff, "center");
		add(text);
		
		scrollFactor.x = scrollFactor.y = 0;
	}
	
	override public function destroy():Void 
	{
		text = null;
		super.destroy();
	}
	
	public function show():Void
	{
		visible = true;
	}
	
	public function hide():Void
	{
		visible = false;
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
}