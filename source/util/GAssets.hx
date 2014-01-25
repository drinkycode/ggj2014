package util;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * Holds all static vars for various assets in-game
 */
class GAssets
{
	
	public static inline var LOC_DATA:String = "assets/data/";
	public static inline var LOC_IMGS:String = "assets/images/";
	public static inline var LOC_MUSIC:String = "assets/music/";
	public static inline var LOC_SOUNDS:String = "assets/sounds/";
	
	public static function getFile(File:String, Location:String = LOC_IMGS, FileType:String = "png"):String
	{
		return Location + File + "." + FileType;
	}
	
}