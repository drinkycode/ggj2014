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
import game.objs.kitchen.Apple;
import game.objs.kitchen.KitchenTable;
import game.objs.livingroom.Books;
import game.objs.livingroom.CoffeeTable;
import game.objs.livingroom.LivingRoomTable;
import game.objs.livingroom.TableJar;
import game.objs.livingroom.TV;
import game.objs.livingroom.TVTable;
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
	public var gtextareas:FlxGroup;
	
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
		level = new FlxOgmoLoader(GAssets.getFile("newhouse", GAssets.LOC_DATA, "oel")); 
		
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
		
		
		human = new Human(0, 0);
		human.sprite.visible = false;
		//human.addWaypoint(1340, 900);
		//human.addWaypoint(1340, 500);
		//human.move();
		
		
		gobjs = new FlxGroup();
		gtextareas = new FlxGroup();
		hitboxes = new FlxGroup();		
		
		// Load objects in lvl
		level.loadEntities(loadHitbox, "collide");
		level.loadEntities(loadEntity, "entities");
		
		cameraFollow = new FlxObject(0, 0, 1, 1);
		
		FlxG.worldBounds.set(0, 0, 1600, 1600);
		FlxG.camera.setBounds(0, 0, 1600, 1600);
		FlxG.camera.follow(cameraFollow, FlxCamera.STYLE_TOPDOWN, new FlxPoint(0, 0), 2);
		
		add(tilemap);
		add(gobjs);
		add(gtextareas);
		
		
		add(human);
		add(player);
		
		add(hitboxes);
		
		/*addGameObject(new ChewToy(680, 620));
		
		addGameObject(new LivingRoomTable(750, 600));
		addGameObject(new TableJar(750, 592));*/
		
		linkGameObjects(); // Links parent-child objects together
	}
	
	override public function destroy():Void
	{
		tilemap = null;
		gobjs = null;
		gtextareas = null;
		
		player = null;
		human = null;
		
		hitboxes = null;
		
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
		
		var o:BaseGObject;
		
		switch (EntType.toLowerCase())	
		{
			case "player":
				//add player to group or playstate
				player = new Player(ex, ey);
				
			case "dog_bed":
				o = new BaseGObject(ex, ey, "dogbed", 64, 64, "me awake", "no tired", false);
				//o.setupHitbox(50, 64, 7, 0);
				addGameObject(o);
				
			case "bed":
				o = new BaseGObject(ex, ey, "bed1", 128, 128, "no master", "bed cold", false);
				o.setupHitbox(96, 128, 16, 0);
				o.sndFile = o.postSndFile = GAssets.getFile("clothes_rustle", GAssets.LOC_SOUNDS, "mp3");
				addGameObject(o);
				
			case "clothes_a":
				o = new BaseGObject(ex, ey, "clothes1", 0, 0, "master's smell", "master's smell", false, 32, 32);
				o.sndFile = o.postSndFile = GAssets.getFile("clothes_rustle", GAssets.LOC_SOUNDS, "mp3");
				addGameObject(o);
				
			case "clothes_b":
				o = new BaseGObject(ex, ey, "clothes2", 0, 0, "young master smell", "young master smell", false, 32, 32);
				o.sndFile = o.postSndFile = GAssets.getFile("clothes_rustle", GAssets.LOC_SOUNDS, "mp3");
				addGameObject(o);
				
			case "chew_toy_a":
				o = new BaseGObject(ex, ey, "chewtoy1", 0, 0, "my friend", "my friend");
				o.sndFile = o.postSndFile = GAssets.getFile("squeeky_toy", GAssets.LOC_SOUNDS, "mp3");
				addGameObject(o);
				
			case "chew_toy_b":
				o = new BaseGObject(ex, ey, "chewtoy2", 0, 0, "...my enemy", "...my enemy");
				o.sndFile = GAssets.getFile("squeeky_toy", GAssets.LOC_SOUNDS, "mp3");
				addGameObject(o);
				
			case "toilet":
				o = new BaseGObject(ex, ey, EntType, 64, 64, "drink water", "very tasty", false);
				o.setupHitbox(40, 48, 12, 16);
				o.badInteraction = true;
				o.sndFile = o.postSndFile = GAssets.getFile("toilet", GAssets.LOC_SOUNDS, "mp3");
				addGameObject(o);
				
			case "bathtub":
				addGameObject(new BaseGObject(ex, ey, EntType, 0, 0, "no wet now", "i hate tub", true, 112, 64));
				
			case "sink":
				o = new BaseGObject(ex, ey, "bathroom_sink", 0, 0);
				o.setupHitbox(50, 120, 7, 0);
				addGameObject(o);
				
			case "bath_mat":
				addGameObject(new BaseGObject(ex, ey, "bathroom_mat"));
				
			case "kid_toilet":
				o = new BaseGObject(ex, ey, EntType, 64, 64, "drink water", "very tasty", false);
				o.setupHitbox(40, 48, 12, 16);
				o.badInteraction = true;
				o.sndFile = o.postSndFile = GAssets.getFile("toilet", GAssets.LOC_SOUNDS, "mp3");
				addGameObject(o);
				
			case "kid_bathtub":
				addGameObject(new BaseGObject(ex, ey, EntType, 0, 0, "no wet now", "i hate tub", true, 112, 64));
				
			case "kid_sink":
				o = new BaseGObject(ex, ey, EntType, 0, 0);
				o.setupHitbox(50, 120, 7, 0);
				addGameObject(o);
				
			case "kid_bath_mat":
				addGameObject(new BaseGObject(ex, ey, EntType));
				
			case "picture_a":
				addGameObject(new BaseGObject(ex, ey, EntType, 0, 0, "master and young master and me", "master and young master and me"));
				
			case "picture_b":
				addGameObject(new BaseGObject(ex, ey, EntType, 0, 0, "young master and me!", "young master and me!"));
				
			case "sidetable":
				addGameObject(new LivingRoomTable(ex, ey));
				
			case "vase":
				addGameObject(new TableJar(ex, ey));
				
			case "kid_bed":
				o = new BaseGObject(ex, ey, "bed2", 0, 0, "young master no here", "young master no here", false);
				o.setupHitbox(96, 64, 16, 0);
				o.sndFile = o.postSndFile = GAssets.getFile("clothes_rustle", GAssets.LOC_SOUNDS, "mp3");
				addGameObject(o);
				
			case "stuffed_animal":
				o = new BaseGObject(ex, ey, EntType, 32, 32, "where young master", "no tell me", false);
				o.badInteraction = true;
				o.sndFile = GAssets.getFile("clothes_rip", GAssets.LOC_SOUNDS, "mp3");
				addGameObject(o);
				
			case "toy":
				o = new BaseGObject(ex, ey, EntType, 32, 32, "where young master", "young master upset");
				o.badInteraction = true;
				o.sndFile = GAssets.getFile("wood_crack", GAssets.LOC_SOUNDS, "mp3");
				addGameObject(o);
				
			case "ducky":
				o = new BaseGObject(ex, ey, EntType, 0, 0, "ducky friend", "no tell me");
				o.sndFile = o.postSndFile = GAssets.getFile("squeeky_toy", GAssets.LOC_SOUNDS, "mp3");
				addGameObject(o);
				
			case "dog_bowl":
				o = new BaseGObject(ex, ey, EntType, 64, 64, "master give food!", "i ate it");
				addGameObject(o);
				
			case "water_bowl":
				o = new BaseGObject(ex, ey, EntType, 64, 64, "water here too", "more tasty");
				addGameObject(o);
				
			case "dining_table":
				addGameObject(new KitchenTable(ex, ey));
				
			case "apple":
				addGameObject(new Apple(ex, ey));
				
			case "chair":
				o = new BaseGObject(ex, ey, "kitchen_chair", 64, 64, "i let go", "territory me", false);
				o.setupHitbox(48, 64, 8, 0);
				o.badInteraction = true;
				o.sndFile = GAssets.getFile("pee", GAssets.LOC_SOUNDS, "mp3");
				addGameObject(o);
				
			case "tv_table":
				addGameObject(new TVTable(ex,ey));
				
			case "tv":
				addGameObject(new TV(ex,ey));
				
			case "couch":
				o = new BaseGObject(ex, ey, EntType, 64, 128, "where is master", "no master upset");
				o.badInteraction = true;
				o.sndFile = GAssets.getFile("clothes_rip", GAssets.LOC_SOUNDS, "mp3");
				addGameObject(o);
				
			case "recliner":
				o = new BaseGObject(ex, ey, EntType, 64, 64, "master not here", "me upset");
				o.badInteraction = true;
				o.sndFile = GAssets.getFile("clothes_rip", GAssets.LOC_SOUNDS, "mp3");
				addGameObject(o);
				
			case "coffee_table":
				addGameObject(new CoffeeTable(ex, ey));
				
			case "books":
				addGameObject(new Books(ex, ey));
				
			case "tree":
				addGameObject(new BaseGObject(ex, ey, EntType, 64, 64, "", ""));
				
			case "candy":
				addGameObject(new BaseGObject(ex, ey, EntType, 64, 64, "CANDY!", "sweet"));
				
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
	
	public function stopCameraFollow():Void
	{
		FlxG.camera.follow(null);
	}
	
	override public function update():Void
	{
		super.update();
		cameraFollow.x = player.sprite.x + 12;
		cameraFollow.y = player.sprite.y - 16;
		
		//FlxG.collide(tilemap, player);
		
		if (useHitboxes)
		{
			FlxG.collide(hitboxes, player.sprite);
		}
	}
	
}