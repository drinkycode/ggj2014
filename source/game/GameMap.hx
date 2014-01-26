package game;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import game.objs.BaseGObject;
import game.objs.livingroom.LivingRoomTable;
import game.objs.livingroom.TableJar;
import game.objs.misc.ChewToy;
import util.GAssets;

/**
 * Level loader for game
 * 
 * @author Michael Lee
 */
class GameMap extends FlxGroup
{

	public var level:FlxOgmoLoader;
	
	public var player:Player;
	public var human:Human;
	
	public var tilemap:FlxTilemap;
	public var gobjs:FlxGroup;
	
	public var cameraFollow:FlxObject;
	public var hitboxes:FlxGroup;
	
	public var useHitboxes:Bool = true;
	public var numGameObjs:Int = 0;
	
	public function new():Void 
	{
		super();
	}
	
	public function create():Void
	{
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
		
		gobjs = new FlxGroup();
		hitboxes = new FlxGroup();		
		
		// Load objects in lvl
		level.loadEntities(loadHitbox, "collide");
		level.loadEntities(loadEntity, "entities");
		
		cameraFollow = new FlxObject(0, 0, 1, 1);
		
		FlxG.worldBounds.set(0, 0, 2048, 2048);
		FlxG.camera.setBounds(0, 0, 2048, 2048);
		FlxG.camera.follow(cameraFollow, FlxCamera.STYLE_TOPDOWN, new FlxPoint(0, 0), 2);
		
		add(tilemap);
		add(gobjs);
		
		
		human = new Human(1800, 900);
		
		human.addWaypoint(1340, 900);
		human.addWaypoint(1340, 500);
		
		human.move();
		
		
		add(human);
		add(player);
		
		add(hitboxes);
		
		addGameObject(new ChewToy(680, 620));
		
		addGameObject(new LivingRoomTable(750, 600));
		addGameObject(new TableJar(750, 592));
		
		linkGameObjects(); // Links parent-child objects together
	}
	
	override public function destroy():Void
	{
		tilemap = null;
		player = null;
		gobjs = null;
		cameraFollow = null;
		
		super.destroy();
	}
	
	public function loadHitbox(HitType:String, Data:Xml):Void
	{
		var hx:Float = Std.parseFloat(Data.get("x"));
		var hy:Float = Std.parseFloat(Data.get("y"));
		var hw:Int = Std.parseInt(Data.get("w"));
		var hh:Int = Std.parseInt(Data.get("h"));
		addHitbox(hx, hy, hw, hh);
	}
	
	public function addHitbox(HX:Float, HY:Float, HW:Int, HH:Int):Void
	{
		hitboxes.add(Hitbox.create(HX, HY, HW, HH));
	}
	
	public function loadEntity(EntType:String, Data:Xml):Void
	{
		var ex:Float = Std.parseFloat(Data.get("x"));
		var ey:Float = Std.parseFloat(Data.get("y"));
		
		switch (EntType.toLowerCase())	
		{
			case "player":
				//add player to group or playstate
				player = new Player(ex, ey);
				
			case "human":
				
			case "rocket":
				
			case "star":
				
			case "home":
				
			case "instruct":
				
			case "bird":
				
			default:
				throw "Unrecognized actor type '" + EntType + "' detected in level file.";
		}
	}
	
	private function addGameObject(Obj:BaseGObject):Void
	{
		gobjs.add(Obj);
		numGameObjs++;
	}
	
	private function linkGameObjects():Void
	{
		var i:Int;
		var j:Int;
		var l:Int = gobjs.members.length;
		
		var gobj:BaseGObject;
		for (i in 0 ... l)
		{
			gobj = cast gobjs.members[i];
			if (gobj.childObjName != "")
			{
				var childObjName:String = gobj.childObjName;
				
				var childObj:BaseGObject = null;
				for (j in 0 ... l)
				{
					if (i == j) continue;
					childObj = cast gobjs.members[j];
					if (childObj.objName == childObjName)
					{
						gobj.childObject = childObj;
						break;
					}
				}
			}
		}
	}
	
	override public function update():Void
	{
		super.update();
		cameraFollow.x = player.sprite.x + 12;
		cameraFollow.y = player.sprite.y + 0;
		
		//FlxG.collide(tilemap, player);
		
		if (useHitboxes)
		{
			FlxG.collide(hitboxes, player.sprite);
		}
	}
	
}