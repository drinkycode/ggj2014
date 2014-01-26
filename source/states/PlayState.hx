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
import flixel.plugin.TweenManager;
import flixel.system.frontEnds.CameraFrontEnd;
import flixel.system.frontEnds.SoundFrontEnd;
import flixel.system.input.keyboard.FlxKey;
import flixel.system.input.keyboard.FlxKeyboard;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
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
	public var gameTimer:Float = 2 * 60; // Seconds
	
	public var gui:GameGUI;
	public var gmap:GameMap;
	
	public var badInteractions:Int = 0;
	
	public var forceEnding:Int = -1;
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
			if ((gameTimer <= 0) || (forceEnding != -1))
			{
				// Fire ending here
				state = 3;
				gmap.player.allowInput = false;
				
				if (forceEnding != -1)
				{
					_ending = forceEnding;
				}
				else if (badInteractions <= 3)
				{
					_ending = 2;
				}
				else
				{
					_ending = 3;
				}
				
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
		
		gmap.stopCameraFollow();
		
		// Setup endings
		switch (_ending) 
		{
			case 1: 
				gmap.player.sprite.x = 150;
				gmap.player.sprite.y = 150;
				gmap.player.sprite.facing = FlxObject.RIGHT;
				
				positionHuman(220, 100);
				
				gui.callPopup(220, 100, "Where did Echo go? I'm so alone now...");
				
				FlxG.camera.scroll.x = 100;
				FlxG.camera.scroll.y = 100;
				
			// Good ending
			case 2: 
				positionPlayer(1454, 544);
				gmap.player.sprite.facing = FlxObject.RIGHT;
				
				positionHuman(1500, 500);
				gmap.human.sprite.facing = FlxObject.LEFT;
				gmap.human.sprite.animation.play("scold");
				
				FlxG.camera.scroll.x = 1340;
				FlxG.camera.scroll.y = 340;
				
			// Bad ending
			case 3:
				positionPlayer(1454, 544);
				gmap.player.sprite.facing = FlxObject.RIGHT;
				
				positionHuman(1500, 500);
				gmap.human.sprite.facing = FlxObject.LEFT;
				gmap.human.sprite.animation.play("scold");
				
				FlxG.camera.scroll.x = 1340;
				FlxG.camera.scroll.y = 340;
		}
	}
	
	private function positionPlayer(X:Float, Y:Float):Void
	{
		gmap.player.sprite.x = X;
		gmap.player.sprite.y = Y;
	}
	
	private function positionHuman(X:Float, Y:Float):Void
	{
		gmap.human.sprite.visible = true;
		gmap.human.sprite.x = X;
		gmap.human.sprite.y = Y;
	}
	
	private function callHumanPopup(Message:String, Duration:Float = 5):Void
	{
		gui.callPopup(gmap.human.sprite.x, gmap.human.sprite.y, Message, Duration);
	}
	
	private function gotoEnding():Void
	{
		switch (_ending) 
		{
			case 1:
				
			case 2:
				callHumanPopup("Echo come here!", 5);
				FlxTween.manager.add(new FlxTween(5, FlxTween.ONESHOT, goodEnding1), true);
				FlxTween.manager.add(new FlxTween(9, FlxTween.ONESHOT, goodEnding2), true);
				FlxTween.manager.add(new FlxTween(15, FlxTween.ONESHOT, goodEnding3), true);
				FlxTween.manager.add(new FlxTween(21, FlxTween.ONESHOT, goodEnding4), true);
				FlxTween.manager.add(new FlxTween(25, FlxTween.ONESHOT, goodEnding5), true);
				FlxTween.manager.add(new FlxTween(31, FlxTween.ONESHOT, fadeToMenu), true);
				
			case 3:
				callHumanPopup("ECHO! BAD DOG!", 5);
				FlxTween.manager.add(new FlxTween(6, FlxTween.ONESHOT, badEnding1), true);
				FlxTween.manager.add(new FlxTween(12, FlxTween.ONESHOT, badEnding2), true);
				FlxTween.manager.add(new FlxTween(16, FlxTween.ONESHOT, badEnding3), true);
				FlxTween.manager.add(new FlxTween(22, FlxTween.ONESHOT, badEnding4), true);
				FlxTween.manager.add(new FlxTween(28, FlxTween.ONESHOT, badEnding5), true);
				FlxTween.manager.add(new FlxTween(32, FlxTween.ONESHOT, badEnding6), true);
				FlxTween.manager.add(new FlxTween(40, FlxTween.ONESHOT, fadeToMenu), true);
		}
	}
	
	private function goodEnding1(T:FlxTween = null):Void
	{
		gui.callTextbox("master is back!");
	}
	private function goodEnding2(T:FlxTween = null):Void
	{
		callHumanPopup("Don't look at me like that....", 5);
	}
	private function goodEnding3(T:FlxTween = null):Void
	{
		callHumanPopup("I can't do anything...", 5);
	}
	private function goodEnding4(T:FlxTween = null):Void
	{
		gui.callTextbox("yay master");
	}
	private function goodEnding5(T:FlxTween = null):Void
	{
		gmap.human.sprite.animation.play("cry");
		gui.callPopup(gmap.human.sprite.x, gmap.human.sprite.y, "We'll get through this somehow...", 99);
	}
	
	private function badEnding1(T:FlxTween = null):Void
	{
		callHumanPopup("What should I do with you?!", 5);
	}
	private function badEnding2(T:FlxTween = null):Void
	{
		gui.callTextbox("master is here!");
	}
	private function badEnding3(T:FlxTween = null):Void
	{
		callHumanPopup("Don't look at me like that....", 5);
	}
	private function badEnding4(T:FlxTween = null):Void
	{
		callHumanPopup("I can't do anything...", 5);
	}
	private function badEnding5(T:FlxTween = null):Void
	{
		gui.callTextbox("yay master");
	}
	private function badEnding6(T:FlxTween = null):Void
	{
		gmap.human.sprite.animation.play("cry");
		gui.callPopup(gmap.human.sprite.x, gmap.human.sprite.y, "We'll get through this somehow...", 99);
	}
	
	private function fadeToMenu(T:FlxTween = null):Void
	{
		FlxG.camera.fade(0xff000000, 2.5, false, gotoMenu);
	}
	
	private function gotoMenu():Void
	{
		FlxG.switchState(new MenuState());
	}

	
}