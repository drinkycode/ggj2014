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
import flixel.system.FlxSound;
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
	
	public var state:Int = 1;
	public var gameTimer:Float = 105; // Seconds
	
	public var gui:GameGUI;
	public var gmap:GameMap;
	public var hometext:FlxText;
	
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
		FlxG.mouse.hide();
		
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
		
		FlxG.camera.fade(0xff000000, 3, true, startGame);
		
		gmap.player.allowInput = false;
		FlxG.sound.playMusic(GAssets.getFile("sneaky_adventure", GAssets.LOC_MUSIC, "mp3"), 0.5);
		
		hometext = new FlxText(0, 30, FlxG.width, "Echo, I'm home!");
		hometext.setFormat(GAssets.getFile("HelvetiHand", GAssets.LOC_DATA, "ttf"), 20, 0xffffff, "center", FlxText.BORDER_OUTLINE, 0x000000, true);
		hometext.scrollFactor.x = hometext.scrollFactor.y = 0;
		hometext.visible = false;
		add(hometext);
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
		
		//if (FlxG.keyboard.anyJustPressed(["ONE"]))
		//{
			//gmap.useHitboxes = !gmap.useHitboxes;
		//}
		
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
				else if (!gmap.player.movedOnce)
				{
					_ending = 4;
					hometext.visible = true;
				}
				else if (badInteractions <= 6)
				{
					_ending = 2;
					hometext.visible = true;
				}
				else
				{
					_ending = 3;
					hometext.visible = true;
				}
				FlxG.camera.fade(0xff000000, 1.5, false, onFadeComplete, true);
			}
		}
		else if (state == 3) // End
		{
			
		}
	}
	
	private function startGame():Void
	{
		state = 2;
		gmap.player.allowInput = true;
	}
	
	private function onFadeComplete():Void
	{
		hometext.visible = false;
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
		}
		FlxG.sound.playMusic(GAssets.getFile("light_thought", GAssets.LOC_MUSIC, "mp3"), 0.5);
		
		FlxG.camera.fade(0xff000000, 1.5, true, gotoEnding, true);
		
		gmap.stopCameraFollow();
		gui.hideTextbox();
		
		gmap.player.ending = true;
		
		var endx:Float;
		var endy:Float;
		// Setup endings
		switch (_ending) 
		{
			// Runaway ending
			case 1: 
				gmap.player.sprite.visible = false;
				
				endx = 1280;
				endy = 992;
				
				positionHuman(endx, endy);
				gmap.human.sprite.facing = FlxObject.RIGHT;
				gmap.human.sprite.animation.play("idle");
				
				FlxG.camera.scroll.x = endx - 212;
				FlxG.camera.scroll.y = endy - 124;
			
				callHumanPopup("ECHO? ECHO!", 6.5);
				
			// Good ending
			case 2: 
				endx = 1056;
				endy = 960;
				
				positionPlayer(endx, endy);
				gmap.player.sprite.animation.play("idle_right");
				gmap.player.facing = FlxObject.RIGHT;
				
				positionHuman(endx+28, endy-44);
				gmap.human.sprite.facing = FlxObject.LEFT;
				gmap.human.sprite.animation.play("idle");
				
				FlxG.camera.scroll.x = endx - 214;
				FlxG.camera.scroll.y = endy - 198;
				
				callHumanPopup("Echo come here!", 4.5);
				
			// Bad ending
			case 3:
				endx = 1120;
				endy = 544;
				
				positionPlayer(endx, endy);
				gmap.player.sprite.animation.play("idle_right");
				gmap.player.facing = FlxObject.RIGHT;
				
				positionHuman(endx+46, endy-44);
				gmap.human.sprite.facing = FlxObject.LEFT;
				gmap.human.sprite.animation.play("scold");
				
				FlxG.camera.scroll.x = endx - 114;
				FlxG.camera.scroll.y = endy - 204;
				
			// Death ending
			case 4:
				gmap.player.sprite.x -= 23;
				//positionPlayer(1454, 544);
				gmap.player.active = false;
				gmap.player.sprite.animation.play("dead");
				
				positionHuman(250, 433);
				gmap.human.sprite.facing = FlxObject.LEFT;
				gmap.human.sprite.animation.play("cry");
				
				//FlxG.camera.scroll.x = 1520;
				//FlxG.camera.scroll.y = 1360;
				
				callHumanPopup("ECHO! ECHO!", 6.5);
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
		gui.callPopup(gmap.human.sprite.x + 34, gmap.human.sprite.y - 34, Message, Duration);
	}
	
	private function gotoEnding():Void
	{
		switch (_ending) 
		{
			case 1:
				FlxTween.manager.add(new FlxTween(6, FlxTween.ONESHOT, runawayEnding1), true);
				FlxTween.manager.add(new FlxTween(12, FlxTween.ONESHOT, runawayEnding2), true);
				FlxTween.manager.add(new FlxTween(20, FlxTween.ONESHOT, fadeToMenu), true);
				
			case 2:
				//callHumanPopup("Echo come here!", 5);
				FlxTween.manager.add(new FlxTween(4, FlxTween.ONESHOT, goodEnding1), true);
				FlxTween.manager.add(new FlxTween(8, FlxTween.ONESHOT, goodEnding2), true);
				FlxTween.manager.add(new FlxTween(14, FlxTween.ONESHOT, goodEnding3), true);
				FlxTween.manager.add(new FlxTween(20, FlxTween.ONESHOT, goodEnding4), true);
				FlxTween.manager.add(new FlxTween(24, FlxTween.ONESHOT, goodEnding5), true);
				FlxTween.manager.add(new FlxTween(30, FlxTween.ONESHOT, goodEnding6), true);
				FlxTween.manager.add(new FlxTween(36, FlxTween.ONESHOT, goodEnding7), true);
				FlxTween.manager.add(new FlxTween(42, FlxTween.ONESHOT, goodEnding8), true);
				FlxTween.manager.add(new FlxTween(42.5, FlxTween.ONESHOT, goodEnding9), true);
				FlxTween.manager.add(new FlxTween(50, FlxTween.ONESHOT, fadeToMenu), true);
				
			case 3:
				callHumanPopup("ECHO! BAD DOG!", 5);
				FlxTween.manager.add(new FlxTween(6, FlxTween.ONESHOT, badEnding1), true);
				FlxTween.manager.add(new FlxTween(12, FlxTween.ONESHOT, badEnding2), true);
				FlxTween.manager.add(new FlxTween(16, FlxTween.ONESHOT, badEnding3), true);
				FlxTween.manager.add(new FlxTween(22, FlxTween.ONESHOT, badEnding4), true);
				FlxTween.manager.add(new FlxTween(28, FlxTween.ONESHOT, badEnding5), true);
				FlxTween.manager.add(new FlxTween(32, FlxTween.ONESHOT, badEnding6), true);
				FlxTween.manager.add(new FlxTween(40, FlxTween.ONESHOT, fadeToMenu), true);
				
			case 4:
				FlxTween.manager.add(new FlxTween(6, FlxTween.ONESHOT, deathEnding1), true);
				FlxTween.manager.add(new FlxTween(12, FlxTween.ONESHOT, deathEnding2), true);
				FlxTween.manager.add(new FlxTween(18, FlxTween.ONESHOT, deathEnding3), true);
				FlxTween.manager.add(new FlxTween(24, FlxTween.ONESHOT, deathEnding4), true);
				FlxTween.manager.add(new FlxTween(32, FlxTween.ONESHOT, fadeToMenu), true);
		}
	}
	
	private function goodEnding1(T:FlxTween = null):Void
	{
		gui.callTextbox("master is back!");
	}
	private function goodEnding2(T:FlxTween = null):Void
	{
		callHumanPopup("I don't know what I would do without you...", 5);
	}
	private function goodEnding3(T:FlxTween = null):Void
	{
		gmap.human.sprite.animation.play("cry");
		callHumanPopup("I'm glad you're here, Echo...", 5);
	}
	private function goodEnding4(T:FlxTween = null):Void
	{
		gui.callTextbox("where young master?");
	}
	private function goodEnding5(T:FlxTween = null):Void
	{
		callHumanPopup("Maggie... she'll be okay...", 5);
	}
	private function goodEnding6(T:FlxTween = null):Void
	{
		callHumanPopup("She wants to see you.", 5);
	}
	private function goodEnding7(T:FlxTween = null):Void
	{
		gmap.player.sprite.facing = FlxObject.LEFT;
		gmap.player.sprite.animation.play("hug");
		gmap.human.sprite.visible = false;
		callHumanPopup("We can get through this, Echo. Definitely.", 5);
	}
	private function goodEnding8(T:FlxTween = null):Void
	{
		FlxG.sound.play(GAssets.getFile("bark", GAssets.LOC_SOUNDS, "mp3"));
		gui.callTextbox("bark bark");
	}
	private function goodEnding9(T:FlxTween = null):Void
	{
		FlxG.sound.play(GAssets.getFile("bark", GAssets.LOC_SOUNDS, "mp3"));
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
		callHumanPopup("Don't look at me like that...", 5);
	}
	private function badEnding4(T:FlxTween = null):Void
	{
		callHumanPopup("I need to deal with you first...", 5);
	}
	private function badEnding5(T:FlxTween = null):Void
	{
		gui.callTextbox("yay master");
	}
	private function badEnding6(T:FlxTween = null):Void
	{
		gmap.human.sprite.animation.play("cry");
		callHumanPopup("Ohh... We'll get through this somehow...", 99);
	}
	
	private function runawayEnding1(T:FlxTween = null):Void
	{
		callHumanPopup("Echo where are you??", 5);
	}
	private function runawayEnding2(T:FlxTween = null):Void
	{
		callHumanPopup("I'm so alone...", 5);
	}
	
	private function deathEnding1(T:FlxTween = null):Void
	{
		callHumanPopup("Oh my god, what happened?", 5);
	}
	private function deathEnding2(T:FlxTween = null):Void
	{
		callHumanPopup("I was only gone for the morning...", 5);
	}
	private function deathEnding3(T:FlxTween = null):Void
	{
		callHumanPopup("First Maggie and now Echo...", 5);
	}
	private function deathEnding4(T:FlxTween = null):Void
	{
		gmap.human.sprite.animation.play("cry");
		callHumanPopup("*sob*", 5);
	}
	
	private function fadeToMenu(T:FlxTween = null):Void
	{
		FlxG.camera.fade(0xff000000, 3.5, false, gotoMenu);
	}
	
	private function gotoMenu():Void
	{
		FlxG.switchState(new MenuState());
	}

	
}