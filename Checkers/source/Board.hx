package;

class Board 
{
	
	

	public function new() 
	{
	
		var v2d = Vector2D.create(3,5);

        v2d[0][0] = "Top Left";
        v2d[2][4] = "Bottom Right";

        trace (v2d);
		
	}
	
}


class Vector2D
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
}