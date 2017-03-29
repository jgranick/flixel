package flixel.graphics.tile; #if (openfl >= "4.0.0")

import flixel.FlxCamera;
import flixel.graphics.frames.FlxFrame;
import flixel.graphics.tile.FlxDrawBaseItem.FlxDrawItemType;
import flixel.math.FlxMatrix;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.ColorTransform;

class FlxDrawTilemapItem extends FlxDrawBaseItem<FlxDrawTilemapItem>
{
	public var drawData:Array<Tile> = [];
	public var position:Int = 0;
	public var numTiles(get, never):Int;
	public var shader:FlxShader;
	public var tilesDirty:Bool;
	
	public function new() 
	{
		super();
		type = FlxDrawItemType.TILEMAP;
	}
	
	override public function reset():Void
	{
		super.reset();
		position = 0;
		shader = null;
	}
	
	override public function dispose():Void
	{
		super.dispose();
		drawData = null;
		shader = null;
	}
	
	override public function addQuad(frame:FlxFrame, matrix:FlxMatrix, ?transform:ColorTransform):Void
	{
		var tile;
		if (position >= drawData.length)
		{
			tile = new Tile();
			tile.tileset = graphics.tileset;
			drawData.push(tile);
		}
		else
		{
			tile = drawData[position];
		}
		tile.matrix.copyFrom(matrix);

		// if (colored && transform != null)
		// {
		// 	setNext(transform.redMultiplier);
		// 	setNext(transform.greenMultiplier);
		// 	setNext(transform.blueMultiplier);
		// }

		// setNext(transform != null ? transform.alphaMultiplier : 1.0);

		// #if (!openfl_legacy && openfl >= "3.6.0")
		// if (hasColorOffsets && transform != null)
		// {
		// 	setNext(transform.redOffset);
		// 	setNext(transform.greenOffset);
		// 	setNext(transform.blueOffset);
		// 	setNext(transform.alphaOffset);
		// }
		// #end
		
		tilesDirty = true;
		position++;
	}
	
	override public function render(camera:FlxCamera):Void
	{
		if (!FlxG.renderTilemap || position <= 0 || !tilesDirty)
			return;
		
		var tilemap = camera.tilemap;
		tilemap.removeTiles();
		
		for (i in 0...position)
		{
			tilemap.addTile(drawData[i]);
		}
		
		// var flags:Int = Tilesheet.TILE_TRANS_2x2 | Tilesheet.TILE_RECT | Tilesheet.TILE_ALPHA;
		
		// if (colored)
		// 	flags |= Tilesheet.TILE_RGB;
		
		// #if (!openfl_legacy && openfl >= "3.6.0")
		// if (hasColorOffsets)
		// 	flags |= Tilesheet.TILE_TRANS_COLOR;
		// #end

		// flags |= blending;

		// #if !(nme && flash)
		// camera.canvas.graphics.drawTiles(graphics.tilesheet, drawData,
		// 	(camera.antialiasing || antialiasing), flags,
		// 	#if !openfl_legacy shader, #end
		// 	position);
		// #end

		tilesDirty = false;
		FlxTilesheet._DRAWCALLS++;
	}
	
	private function get_numTiles():Int
	{
		return drawData.length;
	}
	
	override private function get_numVertices():Int
	{
		return 4 * numTiles;
	}
	
	override private function get_numTriangles():Int
	{
		return 2 * numTiles;
	}
}

#end