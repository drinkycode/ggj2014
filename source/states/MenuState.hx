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
		
		FlxG.mouse.hide();
		
		
		super.create();
		var text:FlxText = new FlxText(0, FlxG.height/3, FlxG.width, "Press X to Start\nArrow Keys to move");
			text.setFormat(GAssets.getFile("awesome", GAssets.LOC_DATA, "ttf"), 16, 0xffffff, "center", FlxText.BORDER_OUTLINE, 0x000000, true);
		
		var title:FlxSprite = new FlxSprite();
		title.loadGraphic(GAssets.getFile("title"));
		add(title);
		add(text);
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
		if (FlxG.mouse.justPressed || FlxG.keyboard.anyJustPressed(["X"]))
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