package flixel.graphics.tile; #if (openfl < "4.0.0")

import openfl.display.Tilesheet;

class FlxTilesheet extends Tilesheet
{
	/**
	 * Tracks total number of `drawTiles()` calls made each frame.
	 */
	public static var _DRAWCALLS:Int = 0;
}

#else

class FlxTilesheet
{
	/**
	 * Tracks total number of `drawTiles()` calls made each frame.
	 */
	public static var _DRAWCALLS:Int = 0;
}

#end