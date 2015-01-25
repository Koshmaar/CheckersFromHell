package;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import haxe.ds.Vector;

class Board 
{
	// total number of white/black checkers on board
	public static var checkers_x : Int = 8; 
	public static var checkers_y : Int = 10;
	
	public static var checker_physical_size : Int = 58;
		
	// 0 black  1 red
	public function GetPieceType( type : Int ) : Int
	{
		if (type == 0)
			return FlxRandom.intRanged(0, 3);
		else
			return FlxRandom.intRanged(4, 7);
	}

	// left top corner: (x: 75 | y: 90)
	// right bottom corner:  (x: 533 | y: 660
	// width/height of one checker board = 55

	// 608  top of bottomest row
	
	// board left top physical 
	public static var board_physical_pos : FlxPoint = new FlxPoint(72, 86);
	
	public static function board_physical_size_x() : Int { return checkers_x * checker_physical_size; } 
	
	public static function board_physical_size_y() : Int { return checkers_y * checker_physical_size; } 
	

	public var the : Array< Array<Checker> >;
	
	
	public function new() 
	{
	}
	
	public function Init()
	{
		//var r = new Representation();
		
		the = Array2D.createChecker(checkers_x, checkers_y);
		var legal : Bool = true;
		
		for (j in 0...checkers_y)
		{
			for (i in 0...checkers_x)
			{
				var c = new Checker();
				c.pos_x = i;
				c.pos_y = j;
				c.x = Board.board_physical_pos.x + i * checker_physical_size ;
				c.y = Board.board_physical_pos.y + j * checker_physical_size ;
				
				c.legal = legal;
				legal = !legal;
				
				c.Init();
				
				the[i][j] = c;
				
			}
			
			legal = !legal;
		}
	}
	
	public function CheckPiecesPositions()
	{
		for (_p in Reg.pieces_group )
		{
			var p : Piece = _p;
			
			p.UpdateBoardPos();
			
		}
		
	}
	
	public function draw() : Void
	{
		
		#if debug
		for (i in 0...checkers_x)
		{
			for (j in 0...checkers_y)
			{
				the[i][j].draw();
				
			}
			
		}
		
		#end
		
	}
	
	
}



/*
class Representation
{
	
	public function new() 
	{
		board = Array2D.createInt(3, 5);
	}
	
	
	public var board : Array< Array<Int> >;

}
*/

class Array2D
{
    public static function createChecker(w:Int, h:Int)
    {
        var a = [];
        for (x in 0...w)
        {
            a[x] = [];
            for (y in 0...h)
            {
                a[x][y] = null;
            }
        }
        return a;
    }
}




/*class Vector2D
{
    public static function create(w:Int, h:Int)
    {
        var v = new Vector(w);
        for (i in 0...w)
        {
            v[i] = new Vector(h);
        }
        return v;
    }
}*/