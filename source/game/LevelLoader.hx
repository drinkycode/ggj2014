package game;

//import haxe.xml.Fast;
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
class LevelLoader extends FlxGroup
{

	public var level:FlxOgmoLoader;
	public var tilemap:FlxTilemap;
	private static var _created:Bool = false;
	
	public var player:Player;
	
	public static function createMap():Void
	{
		if (_created) return;
		_created = true;
	}
	
	public function new():Void 
	{
		super();
		level = new FlxOgmoLoader(GAssets.getFile("house", GAssets.LOC_DATA, "oel")); 
		
		// IMPORTANT: Always collide the map with objects, not the other way around. 
		// This prevents odd collision errors (collision separation code off by 1 px). FlxG.collide(map, obj, notifyCallback);
		tilemap = level.loadTilemap(GAssets.getFile("tiles"), 64, 64, "tiles");
		/*set any other tile layers*/
		
		
		/*set collisions*/
	/*	for(i in 0...2) {
			tilemap.setTileProperties(i, FlxObject.NONE);
		}
		for(i in 2...4) {
			tilemap.setTileProperties(i, FlxObject.ANY);
		}
	*/	
		
		/*load objects in lvl*/
		level.loadEntities(loadEntity, "entities");
		
		FlxG.worldBounds.set(0, 0, 2048, 2048);
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);
		FlxG.camera.setBounds(0, 0, 2048, 2048);
		
		add(tilemap);
		add(player);
		
		
	}
	
	public function loadEntity(type:String, data:Xml):Void
	{
		var x = Std.parseFloat(data.get("x"));
		var y = Std.parseFloat(data.get("y"));
		switch (type.toLowerCase())	{
			case "player":
				//add player to group or playstate
				player = new Player(x, y);
			case "rocket":
			case "star":
			case "home":
			case "instruct":
			case "bird":
			default:
				throw "Unrecognized actor type '" + type + "' detected in level file.";
		}
	}
	
	override public function update():Void
	{
		super.update();
		
		FlxG.collide(tilemap, player);
	}	
}