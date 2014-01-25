package game;

//import haxe.xml.Fast;
import flixel.util.FlxPoint;
import util.GAssets;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;


/**
 * Level loader for game
 * 
 * @author Michael Lee
 */
class GameMap extends FlxGroup
{

	public var level:FlxOgmoLoader;
	
	public var player:Player;
	public var tilemap:FlxTilemap;
	public var cameraFollow:FlxObject;
	
	public function new():Void 
	{
		super();
		level = new FlxOgmoLoader(GAssets.getFile("house", GAssets.LOC_DATA, "oel")); 
		
		// IMPORTANT: Always collide the map with objects, not the other way around. 
		// This prevents odd collision errors (collision separation code off by 1 px). FlxG.collide(map, obj, notifyCallback);
		tilemap = level.loadTilemap(GAssets.getFile("tiles"), 64, 64, "tiles");
		
		/*set any other tile layers*/
		
		/*set collisions*/
		/*for(i in 0...2) 
		{
			tilemap.setTileProperties(i, FlxObject.NONE);
		}
		for(i in 2...4) 
		{
			tilemap.setTileProperties(i, FlxObject.ANY);
		}*/	
		
		/*load objects in lvl*/
		level.loadEntities(loadEntity, "entities");
		
		cameraFollow = new FlxObject(0, 0, 1, 1);
		
		FlxG.worldBounds.set(0, 0, 2048, 2048);
		FlxG.camera.setBounds(0, 0, 2048, 2048);
		FlxG.camera.follow(cameraFollow, FlxCamera.STYLE_TOPDOWN, new FlxPoint(0, 0), 2);
		
		add(tilemap);
		add(player);
	}
	
	override public function destroy():Void
	{
		tilemap = null;
		player = null;
		cameraFollow = null;
		
		super.destroy();
	}
	
	public function loadEntity(EntType:String, Data:Xml):Void
	{
		var x:Float = Std.parseFloat(Data.get("x"));
		var y:Float = Std.parseFloat(Data.get("y"));
		
		switch (EntType.toLowerCase())	
		{
			case "player":
				//add player to group or playstate
				player = new Player(x, y);
				
			case "rocket":
				
			case "star":
				
			case "home":
				
			case "instruct":
				
			case "bird":
				
			default:
				throw "Unrecognized actor type '" + EntType + "' detected in level file.";
		}
	}
	
	override public function update():Void
	{
		super.update();
		cameraFollow.x = player.x + 48;
		cameraFollow.y = player.y + 48;
		
		FlxG.collide(tilemap, player);
	}	
}