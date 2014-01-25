package gui;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

/**
 * Main game gui
 * 
 * @author Michael Lee
 */
class GameGUI extends FlxGroup
{
	
	private var _textbox:Textbox;

	public function new() 
	{
		super();
		
		_textbox = new Textbox();
		add(_textbox);
	}
	
	override public function destroy():Void
	{
		_textbox = null;
		super.destroy();
	}
	
	override public function update():Void
	{
		super.update();
	}
	
	public function callTextbox(Message:String):Void
	{
		_textbox.show(Message);
	}
	
}