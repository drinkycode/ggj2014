package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.system.frontEnds.CameraFrontEnd;
import flixel.system.frontEnds.SoundFrontEnd;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import game.LevelLoader;
import game.Player;
import gui.GameGUI;


/**
 * Main game state
 */
class PlayState extends FlxState
{
	
	public var hitboxes:FlxGroup;
	
	public var player:Player;
	public var gui:GameGUI;
	public var level_load:LevelLoader;
	
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
		
		level_load = new LevelLoader();
		
		/*hitboxes = new FlxGroup();
		
		player = new Player();
		gui = new GameGUI();
		
		add(hitboxes); // Possibly comment out?
		
		add(player);
		add(gui);*/
		add(level_load);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		hitboxes = null;
		
		player = null;
		gui = null;
		
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		//FlxG.collide(player, hitboxes);
	}	
}