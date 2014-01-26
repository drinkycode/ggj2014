package game.objs.livingroom;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import game.objs.BaseGObject;
import util.GAssets;

/**
 * Table
 * 
 * @author Michael Lee
 */
class TVTable extends BaseGObject
{
	
	private var _x:Float;
	private var _fxShakeDuration:Float = 0;
	private var _fxShakeIntensity:Float = 0.03;
	
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y, "", 0, 0, "", "", false);
		
		objName = "tv_table";
		preInteractionMessage = "people in here";
		postInteractionMessage = "thing fell off";
		requiredCalls = 3;
		childObjName = "tv";
		
		setupHitbox(48, 100);
		
		preSndFile = sndFile = GAssets.getFile("wood_rattle", GAssets.LOC_SOUNDS, "mp3");
		
		interactionCooldown = 1;
		
		_x = X;
	}
	
	override private function setupSprite():Void 
	{
		super.setupSprite();
		loadGraphic(GAssets.getFile("tv_table"));
		_imageWidth = 32;
		_imageHeight = 64;
		
		//G.playstate.gmap.addHitbox(x, y, 32, 64);
	}
	
	override private function doInteraction():Void 
	{
		super.doInteraction();
		_fxShakeDuration = 0.66;
	}
	
	override private function doPreInteraction():Void 
	{
		super.doPreInteraction();
		_fxShakeDuration = 0.66;
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (_fxShakeDuration > 0)
		{
			_fxShakeDuration -= FlxG.elapsed;
			x = _x + (FlxRandom.float() * _fxShakeIntensity * width * 2 - _fxShakeIntensity * width);
		}
	}
	
}