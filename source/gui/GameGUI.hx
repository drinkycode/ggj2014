package gui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import util.GAssets;

/**
 * Main game gui
 * 
 * @author Michael Lee
 */
class GameGUI extends FlxGroup
{
	
	private var _textbox:Textbox;
	private var _interact:FlxSprite;
	private var _t:Float;

	public function new() 
	{
		super();
		
		_textbox = new Textbox();
	
		
		_interact = new FlxSprite(7, 286);
		_interact.loadGraphic(GAssets.getFile("gui_interact"));
		//_interact.scrollFactor.x = _interact.scrollFactor.y = 0;
		_interact.active = false;
		_interact.moves = false;
		_interact.visible = false;
		
		add(_interact);
		add(_textbox);
	}
	
	override public function destroy():Void
	{
		_textbox = null;
		_interact = null;
		super.destroy();
	}
	
	override public function update():Void
	{
		super.update();
		_t += FlxG.elapsed; // not used, but have interaction button bounce a bit
	}
	
	public function callTextbox(Message:String):Void
	{
		_textbox.show(Message);
	}
	
	public function showInteractionButton(X:Float, Y:Float):Void
	{
		_interact.x = X;
		_interact.y = Y;
		_interact.visible = true;
	}
	
	public function hideInteractionButton():Void
	{
		_interact.visible = false;
	}
	
}