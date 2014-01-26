package states;

import flash.display.BlendMode;
import flash.display.Stage;
import flash.filters.BlurFilter;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.system.frontEnds.CameraFrontEnd;
import flixel.system.frontEnds.SoundFrontEnd;
import flixel.system.input.keyboard.FlxKey;
import flixel.system.input.keyboard.FlxKeyboard;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import game.GameMap;
import game.Player;
import gui.GameGUI;
import util.GAssets;


/**
 * Main game state
 */
class PlayState extends FlxState
{
	
	public var state:Int = 1;
	public var gameTimer:Float = 3 * 60; // Seconds
	
	public var gui:GameGUI;
	public var gmap:GameMap;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		G.playstate = this;
		
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		super.create();
		
		gmap = new GameMap();
		gmap.create();
		
		
		gui = new GameGUI();
		
		add(gmap);
		add(gui);
		
		
		//var blur:FlxSprite = new FlxSprite();
		//blur.loadGraphic(GAssets.getFile("blur"));
		//blur.scrollFactor.x = blur.scrollFactor.y = 0;
		//blur.alpha = 0.15;
		//add(blur);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		G.playstate = null;
		gmap = null;
		gui = null;
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		if (FlxG.keyboard.anyJustPressed(["ONE"]))
		{
			gmap.useHitboxes = !gmap.useHitboxes;
		}
		
		if (state == 1) // Intro
		{
			
		}
		else if (state == 2) // Main game loop
		{
			gameTimer -= FlxG.elapsed;
			if (gameTimer <= 0)
			{
				// Fire ending here
				state = 3;
			}
		}
		else if (state == 3) // End
		{
			
		}
		
		//FlxG.collide(player, hitboxes);
	}	
}