package;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;

class Checker extends FlxSprite
{
	public function new() 
	{ 
		super(0, 0);
		
		
	}
	
	// called after seting legal
	public function Init()
	{
		
		#if debug
		makeGraphic(Board.checker_physical_size, Board.checker_physical_size, legal ? FlxColor.FOREST_GREEN : FlxColor.RED);
		alpha = 0.35;
		
		#end
	}
	
	// on board
	public var pos_x : Int;
	public var pos_y : Int;
	
	// physical pos is FlxSprite.xy
	// left top corner
	
	public var legal : Bool;
	
	
	public function getMidPoint() : FlxPoint
	{
		return new FlxPoint( x + Board.checker_physical_size / 2,
							 y + Board.checker_physical_size / 2 );
	}
	
}