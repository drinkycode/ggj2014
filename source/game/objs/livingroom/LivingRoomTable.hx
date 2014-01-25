package game.objs.livingroom;
import game.objs.BaseGObject;

/**
 * ...
 * @author Michael Lee
 */
class LivingRoomTable extends BaseGObject
{

	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
		objName = "living_room_table";
		preInteractionMessage = "*shake table*";
		postInteractionMessage = "thing broke master upset";
		requiredCalls = 3;
		childObjName = "table_jar";
	}
	
	override private function setupSprite():Void 
	{
		super.setupSprite();
		
		makeGraphic(40, 40, 0xffffffff);
		color = 0xff0000;
	}
	
	override private function doInteraction():Void 
	{
		super.doInteraction();
		//color = 0x000000;
	}
	
}