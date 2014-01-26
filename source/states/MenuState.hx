package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.input.keyboard.FlxKeyboard;
import flixel.system.input.mouse.FlxMouse;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import util.GAssets;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	private var _playGame:Bool = false;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		super.create();
		
		var title:FlxSprite = new FlxSprite();
		title.loadGraphic(GAssets.getFile("title"));
		add(title);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (FlxG.mouse.justPressed || FlxG.keyboard.anyJustPressed(["X", "UP", "DOWN", "LEFT", "RIGHT"]))
		{
			playGame();
		}
		
		super.update();
	}
	
	public function playGame():Void
	{
		if (_playGame) return;
		_playGame = true;
		FlxG.camera.fade(0xff000000, 1.5, false, gotoGame);
	}
	
	private function gotoGame():Void 
	{
		FlxG.switchState(new PlayState());
	}
}