package;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import haxe.ds.Vector;

class Board 
{
	
	public static var size_x : Int = 6;
	public static var size_y : Int = 6;

	public function new() 
	{
	
	/*	var v2d = Vector2D.create(3,5);

        v2d[0][0] = "Top Left";
        v2d[2][4] = "Bottom Right";

        trace (v2d);*/
		
	}
	
	
	public function dostuff()
	{
		var r = new Representation();
		
		//trace( r.board );
		
	}
	
}

class Representation
{
	
	public function new() 
	{
		board = Array2D.createInt(3, 5);
	}
	
	
	public var board : Array< Array<Int> >;

}


class Array2D
{
    public static function createInt(w:Int, h:Int)
    {
        var a = [];
        for (x in 0...w)
        {
            a[x] = [];
            for (y in 0...h)
            {
                a[x][y] = 0;
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