package game;

import flixel.animation.FlxAnimationController;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.system.frontEnds.SoundFrontEnd;
import flixel.system.input.keyboard.FlxKey;
import flixel.system.input.keyboard.FlxKeyboard;
import flixel.system.input.keyboard.FlxKeyShortcuts;
import flixel.util.FlxMath;
import flixel.util.loaders.TexturePackerData;
import game.objs.BaseGObject;
import util.GAssets;
import util.Util;

/**
 * Doggy doge
 * 
 * @author Michael Lee
 */
class Player extends FlxGroup
{

	public static inline var SPEED_X:Float = 384;
	public static inline var SPEED_Y:Float = 364;
	public static inline var MAX_VELOCITY_X:Float = 180;
	public static inline var MAX_VELOCITY_Y:Float = 162;
	public static inline var DRAG_X:Float = 1750;
	public static inline var DRAG_Y:Float = 1750;
	
	public var ending:Bool = false;
	public var orientation:Int = 2;
	
	public var interactionZone:FlxSprite; // Area for active interaction
	public var sprite:FlxSprite;
	public var shadow:FlxSprite;
	
	public var allowInput:Bool = true;
	public var movedOnce:Bool = false;
	
	public var facing:Int = FlxObject.LEFT;
	
	private var _interacted:Bool = false; // Helper bool flag
	private var _pressed:Bool = false;
	
	private var _playingActionAnim:Bool = false;
	
	private var _notMoveTimer:Float = 0;
	
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super();
		
		shadow = new FlxSprite();
		shadow.loadGraphic(GAssets.getFile("shadow"));
		//shadow.makeGraphic(36, 14, 0xff000000);
		shadow.alpha = 0.44;
		shadow.allowCollisions = FlxObject.NONE;
		
		
		sprite = new FlxSprite();
		
		sprite.loadImageFromTexture(new TexturePackerData(GAssets.getFile("player", GAssets.LOC_IMGS, "json"), GAssets.getFile("player")), true, false, "idle_left1.png");
		sprite.animation.addByIndicies("idle_left", 	"idle_left", [1, 2], ".png", 5, true);
		sprite.animation.addByIndicies("idle_right", 	"idle_right", [1, 2], ".png", 5, true);
		sprite.animation.addByIndicies("idle_up", 		"run_up", [1], ".png", 0, false);
		sprite.animation.addByIndicies("idle_down", 	"run_down", [1], ".png", 0, false);
		
		sprite.animation.addByIndicies("run_left", 		"run_left", [1, 2, 3, 4, 5, 6], ".png", 10, true);
		sprite.animation.addByIndicies("run_right", 	"run_right", [1, 2, 3, 4, 5, 6], ".png", 10, true);
		sprite.animation.addByIndicies("run_down", 		"run_down", [1, 2], ".png", 10, true);
		sprite.animation.addByIndicies("run_up", 		"run_up", [1, 2], ".png", 10, true);
		
		sprite.animation.addByIndicies("action_up", 	"action_up", [1, 2], ".png", 5, false);
		sprite.animation.addByIndicies("action_down", 	"action_down", [1, 2], ".png", 5, false);
		sprite.animation.addByIndicies("action_right", 	"action_right", [1, 2], ".png", 5, false);
		sprite.animation.addByIndicies("action_left", 	"action_left", [1, 2], ".png", 5, false);
		
		sprite.animation.addByIndicies("hug", 	"human_hug", [1, 2], ".png", 5, true);
		
		sprite.animation.addByNames("dead", 			["dog_dead.png"], 0, false);
		
		//sprite.loadGraphic(GAssets.getFile("player"), true, true, 64, 64);
		//sprite.animation.add("idle", [0], 0, false);
		//sprite.animation.play("idle");
		
		sprite.width = 44;
		sprite.height = 9;
		sprite.centerOffsets();
		sprite.offset.y += 14;
		sprite.moves = false;
		
		
		interactionZone = new FlxSprite();
		interactionZone.makeGraphic(24, 24, 0xffffffff);
		interactionZone.alpha = 0.5;
		interactionZone.visible = false;
		interactionZone.active = false;
		interactionZone.moves = false;
		
		
		add(shadow);
		add(sprite);
		add(interactionZone);
		
		reset(X, Y);
	}
	
	override public function destroy():Void 
	{
		sprite = null;
		super.destroy();
	}
	
	public function reset(X:Float, Y:Float):Void 
	{
		sprite.x = X;
		sprite.y = Y;
		
		sprite.maxVelocity.x = MAX_VELOCITY_X;
		sprite.maxVelocity.y = MAX_VELOCITY_Y;
		sprite.drag.x = DRAG_X;
		sprite.drag.y = DRAG_Y;
	}
	
	override public function update():Void 
	{
		if (ending)
		{
			var facingOffset:Int = 0;
			if (facing == FlxObject.LEFT)
			{
				facingOffset = 2;
			}
			else
			{
				facingOffset = -1;
			}
			
			super.update();
			shadow.x = sprite.x + 2 + facingOffset;
			shadow.y = sprite.y - 2;
			return;
		}
		
		sprite.acceleration.x = sprite.acceleration.y = 0; // Reset acceleration
		
		var updateOrientation:Bool = false;
		var newOrientation:Int = -1;
		
		var moving:Bool = false;
		var newAnim:String = "";
		var facingOffset:Int = 0;
		
		if (allowInput && !_playingActionAnim)
		{
			if (FlxG.keyboard.anyPressed(["DOWN"]))
			{
				moving = true;
				movedOnce = true;
				
				sprite.acceleration.y = SPEED_Y;
				updateOrientation = true;
				newOrientation = 4;
				newAnim = "run_down";
			}
			else if (FlxG.keyboard.anyPressed(["UP"]))
			{
				moving = true;
				movedOnce = true;
				
				sprite.acceleration.y = -SPEED_Y;
				updateOrientation = true;
				newOrientation = 0;
				newAnim = "run_up";
			}
			
			if (FlxG.keyboard.anyPressed(["LEFT"]))
			{
				moving = true;
				movedOnce = true;
				
				sprite.acceleration.x = -SPEED_X;
				updateOrientation = true;
				newOrientation = 6;
				
				//sprite.facing = FlxObject.LEFT;
				facing = FlxObject.LEFT;
				newAnim = "run_left";
				
				facingOffset = 2;
			}
			else if (FlxG.keyboard.anyPressed(["RIGHT"]))
			{
				moving = true;
				movedOnce = true;
				
				sprite.acceleration.x = SPEED_X;
				updateOrientation = true;
				newOrientation = 2;
				
				//sprite.facing = FlxObject.RIGHT;
				facing = FlxObject.RIGHT;
				newAnim = "run_right";
				
				facingOffset = -1;
			}
		}
		
		var ix:Float = 0;
		var iy:Float = 0;
		
		if (updateOrientation)
		{
			orientation = newOrientation;
		}
		
		switch (orientation) 
		{
			case 0:
				ix = 12;
				iy = -40;
			//case 1:
				//ix = 40;
				//iy = -16;
			case 2:
				ix = 40;
				iy = -12;
			//case 3:
				//ix = 40;
				//iy = 40;
			case 4:
				ix = 12;
				iy = 16;
			//case 5:
				//ix = -16;
				//iy = 40;
			case 6:
				ix = -16;
				iy = -12;
			//case 7:
				//ix = -16;
				//iy = -16;
		}
		
		if (newAnim == "")
		{
			if (orientation == 0)
			{
				newAnim = "idle_up";
			}
			else if (orientation == 4)
			{
				newAnim = "idle_down";
			}
			else if (facing == FlxObject.LEFT)
			{
				if (moving)
				{
					newAnim = "run_left";
				}
				else
				{
					newAnim = "idle_left";
					facingOffset = 2;
				}
			}
			else
			{
				if (moving)
				{
					newAnim = "run_right";
				}
				else
				{
					newAnim = "idle_right";
					facingOffset = -1;
				}
			}
		}
		
		super.update();
		updateMotionExt();
		
		if (_playingActionAnim)
		{
			if (sprite.animation.finished)
			{
				_playingActionAnim = false;
			}
		}
		else if (newAnim != "")
		{
			sprite.animation.play(newAnim);
		}
		
		shadow.x = sprite.x + 2 + facingOffset;
		shadow.y = sprite.y - 2;
		
		interactionZone.x = sprite.x + ix;
		interactionZone.y = sprite.y + iy;
		
		if (allowInput && interactionZone.overlaps(G.playstate.gmap.gobjs))
		{
			//G.playstate.gui.showInteractionButton(interactionZone.x, interactionZone.y);
			checkInteraction();
		}
		else
		{
			G.playstate.gui.hideInteractionButton();
			
			if (allowInput && FlxG.keyboard.anyJustPressed(["X"]))
			{
				FlxG.sound.play(GAssets.getFile("bark", GAssets.LOC_SOUNDS, "mp3"));
			}
		}
		
		if ((sprite.velocity.x != 0) || (sprite.velocity.y != 0))
		{
			checkTextAreas();
		}
		
		if (!movedOnce)
		{
			_notMoveTimer += FlxG.elapsed;
			if (_notMoveTimer >= 45)
			{
				G.playstate.forceEnding = 4;
			}
		}
		
		if (sprite.x >= 1600)
		{
			G.playstate.forceEnding = 1;
		}
	}
	
	/*private function interactionPopup(A:FlxObject, B:FlxObject):Void 
	{
		var gobj:BaseGObject = cast(B, BaseGObject);
		if (gobj != null) 
		{
			G.playstate.gui.showInteractionButton(gobj.x + (gobj.width / 2), gobj.y - 24);
			if (FlxG.keyboard.anyJustPressed(["X"]))
			{
				checkInteraction();
			}
		}
	}*/
	
	private function updateMotionExt():Void
	{
		var delta:Float;
		var velocityDelta:Float;
		
		var dt:Float = FlxG.elapsed;
		
		velocityDelta = 0.5 * (computeVelocity(sprite.velocity.x, sprite.acceleration.x, sprite.drag.x, sprite.maxVelocity.x) - sprite.velocity.x);
		sprite.velocity.x += velocityDelta;
		delta = sprite.velocity.x * dt;
		sprite.velocity.x += velocityDelta;
		sprite.x += delta;
		
		velocityDelta = 0.5 * (computeVelocity(sprite.velocity.y, sprite.acceleration.y, sprite.drag.y, sprite.maxVelocity.y) - sprite.velocity.y);
		sprite.velocity.y += velocityDelta;
		delta = sprite.velocity.y * dt;
		sprite.velocity.y += velocityDelta;
		sprite.y += delta;
	}
	
	private function computeVelocity(Velocity:Float, Acceleration:Float, Drag:Float, Max:Float):Float
	{
		if (Acceleration != 0)
		{
			Velocity += Acceleration * FlxG.elapsed;
			if (Util.sign(Acceleration) != Util.sign(Velocity))
			{
				var drag:Float = Drag * FlxG.elapsed;
				if (Velocity - drag > 0)
				{
					Velocity = Velocity - drag;
				}
				else if (Velocity + drag < 0)
				{
					Velocity += drag;
				}
				else
				{
					Velocity = 0;
				}
			}
		}
		else if(Drag != 0)
		{
			var drag:Float = Drag * FlxG.elapsed;
			if (Velocity - drag > 0)
			{
				Velocity = Velocity - drag;
			}
			else if (Velocity + drag < 0)
			{
				Velocity += drag;
			}
			else
			{
				Velocity = 0;
			}
		}
		if((Velocity != 0) && (Max != 0))
		{
			if (Velocity > Max)
			{
				Velocity = Max;
			}
			else if (Velocity < -Max)
			{
				Velocity = -Max;
			}
		}
		return Velocity;
	}
	
	public function checkInteraction():Void
	{
		sprite.allowCollisions = FlxObject.NONE;
		
		_interacted = false;
		_pressed = FlxG.keyboard.anyJustPressed(["X"]);
		FlxG.overlap(interactionZone, G.playstate.gmap.gobjs, interactWithObject);
		
		sprite.allowCollisions = FlxObject.ANY;
	}
	
	private function interactWithObject(P:Dynamic, Obj:Dynamic):Void
	{
		if (_interacted) return;
		
		if (!Reflect.field(Obj, "canInteract")) return;
		if (interactionZone.overlaps(Obj))
		{
			if (_pressed)
			{
				Reflect.callMethod(Obj, Reflect.field(Obj, "interact"), []);
				
				var actionAnim:String = "action_right";
				if (orientation == 0)
				{
					actionAnim = "action_up";
				}
				else if (orientation == 2)
				{
					actionAnim = "action_right";
				}
				else if (orientation == 4)
				{
					actionAnim = "action_down";
				}
				else if (orientation == 6)
				{
					actionAnim = "action_left";
				}
				sprite.animation.play(actionAnim);
				_playingActionAnim = true;
			}
			G.playstate.gui.showInteractionButton(Obj.x + (Obj.width / 2), Obj.y);
			_interacted = true;
		}
	}
	
	public function checkTextAreas():Void
	{
		FlxG.overlap(sprite, G.playstate.gmap.gtextareas, triggerTextArea);
	}
	
	private function triggerTextArea(P:Dynamic, Obj:Dynamic):Void
	{
		Reflect.callMethod(Obj, Reflect.field(Obj, "trigger"), []);
	}
	
}