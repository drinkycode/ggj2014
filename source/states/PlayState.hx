package states;

import flash.display.BlendMode;
import flash.display.Stage;
import flash.filters.BlurFilter;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
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
	
	public var state:Int = 2;
	public var gameTimer:Float = 3 * 60; // Seconds
	
	public var gui:GameGUI;
	public var gmap:GameMap;
	
	private var _ending:Int = -1;
	
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
				gmap.player.allowInput = false;
				
				_ending = 1;
				FlxG.camera.fade(0xff000000, 1.5, false, onFadeComplete, true);
			}
		}
		else if (state == 3) // End
		{
			
		}
	}
	
	private function onFadeComplete():Void
	{
		FlxG.camera.fade(0xff000000, 1.5, true, gotoEnding, true);
		
		// Setup endings
		switch (_ending) 
		{
			case 1: 
				gmap.player.sprite.x = 150;
				gmap.player.sprite.y = 150;
				gmap.player.sprite.facing = FlxObject.RIGHT;
				
				gmap.human.sprite.visible = true;
				gmap.human.sprite.x = 220;
				gmap.human.sprite.y = 100;
				
				FlxG.camera.scroll.x = 100;
				FlxG.camera.scroll.y = 100;
		}
	}
	
	private function gotoEnding():Void
	{
		switch (_ending) 
		{
			case 1:
				
				
		}
	}

	
}