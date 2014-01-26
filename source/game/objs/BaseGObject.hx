package game.objs;

import flixel.FlxG;
import flixel.FlxSprite;
import util.GAssets;

/**
 * Base game object
 * 
 * @author Michael Lee
 */
class BaseGObject extends FlxSprite
{
	
	public var location:Int = 0;
	public var objName:String = "";
	
	public var canInteract:Bool = true;
	public var interactionState:Int = -1;
	
	public var interactionMessage:String = "";
	public var preInteractionMessage:String = "";
	public var postInteractionMessage:String = "";

	public var callOnce:Bool = false;
	public var called:Bool = false;
	public var calledTimes:Int = 0;
	public var requiredCalls:Int = 1;
	
	public var childObjName:String = "";
	public var childObject:BaseGObject;
	
	public var interactionCooldown:Float = 3;
	
	private var _imageFile:String = "";
	private var _imageWidth:Int = 0;
	private var _imageHeight:Int = 0;
	
	private var _cooldown:Float = 0;
	
	public function new(X:Float = 0, Y:Float = 0, ImageFile:String = "", ImageWidth:Int = 0, ImageHeight:Int = 0) 
	{
		super(X, Y);
		
		_imageFile = ImageFile;
		_imageWidth = ImageWidth;
		_imageHeight = ImageHeight;
		
		setupSprite();
	}
	
	private function setupSprite():Void
	{
		if (_imageFile != "")
		{
			loadGraphic(GAssets.getFile(_imageFile), true, false, _imageWidth, _imageHeight);
			animation.add("idle", [0], 0, false);
			animation.add("interacted", [1], 0, false);
			animation.play("idle");
		}
	}
	
	override public function destroy():Void 
	{
		objName = null;
		
		interactionMessage = null;
		preInteractionMessage = null;
		postInteractionMessage = null;
		
		childObjName = null;
		childObject = null;
		super.destroy();
	}
	
	override public function update():Void 
	{
		super.update();
		_cooldown -= FlxG.elapsed;
	}
	
	public function interact(Force:Bool = false):Void
	{
		if (!Force && !canInteract) return;
		
		if (!callOnce || (callOnce && !called))
		{
			if (_cooldown <= 0)
			{
				called = true;
				calledTimes++;
				
				if (calledTimes == requiredCalls)
				{
					doInteraction();
					if (childObject != null)
					{
						childObject.interact(true);
					}
				}
				else if (calledTimes < requiredCalls)
				{
					doPreInteraction();
				}
				else
				{
					doPostInteraction();
				}
				
				_cooldown = interactionCooldown;
			}
		}
	}
	
	private function doInteraction():Void
	{
		if (interactionMessage != "")
		{
			G.playstate.gui.callTextbox(interactionMessage);
		}
		
		if (_imageFile != "")
		{
			animation.play("interacted");
		}
	}
	
	private function doPreInteraction():Void
	{
		if (preInteractionMessage != "")
		{
			G.playstate.gui.callTextbox(preInteractionMessage);
		}
	}
	
	private function doPostInteraction():Void
	{
		if (postInteractionMessage != "")
		{
			G.playstate.gui.callTextbox(postInteractionMessage);
		}
	}
	
}