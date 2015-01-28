package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import nape.constraint.DistanceJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;

class Piece extends FlxNapeSprite
{
	
	// x and y for game pos are in FlxSprite
	public var pos_board_x : Int; // 0 based
	public var pos_board_y : Int;
	
	public var player : Int = 0;  // 0 for black, 1 for red
	public var is_damka : Bool;
	
	public var dragged : Bool;
	public var prev_pos : FlxPoint;
	
	public var prev_pos_board_x : Int;
	public var prev_pos_board_y : Int;
	
	public var shadow : FlxSprite;
	

	public function new(X: Float, Y: Float, type : Int):Void
	{
		super(X , Y );
		loadGraphic("assets/images/pieces.png", true, 44, 44);
		//animation.frameIndex = FlxRandom.intRanged(0, 6);
		animation.frameIndex = type;
		
		shadow = new FlxSprite();
		shadow.loadGraphic("assets/images/pieces.png", true, 44, 44);
		shadow.animation.frameIndex = type;
		shadow.color = 0x222222;
		shadow.alpha = 0.35;
		
		if (type >= 4)
			player = 1;
		
		antialiasing = true;
		setDrag(0.3, 0.3);
	
		//createRectangularBody(79, 123);
		createCircularBody(18);
		
		// To make pieces don't interact with each other
		body.setShapeFilters(new InteractionFilter(2, 2));
		
		is_damka = false;
		
		// Setup the mouse events
		MouseEventManager.add(this, MouseDragStart, null, onMouseOver, onMouseOut);
		dragged = false;
		prev_pos = new FlxPoint();
	}
	
	private function MouseDragStart(Sprite:FlxSprite)
	{
		prev_pos.x = x;
		prev_pos.y = y;
		prev_pos_board_x = pos_board_x;
		prev_pos_board_y = pos_board_y;
		
		scale.x = scale.y = 1.07;
		shadow.scale.x = shadow.scale.y = 1.12;
		
		trace("");
	
		var body:Body = cast(Sprite, FlxNapeSprite).body;
		
		PlayState.piece_mouse_joint = new DistanceJoint(FlxNapeState.space.world, body, Vec2.weak(FlxG.mouse.x, FlxG.mouse.y), body.worldPointToLocal(Vec2.weak(FlxG.mouse.x, FlxG.mouse.y)), 0, 0);
		PlayState.piece_mouse_joint.stiff = false;
		PlayState.piece_mouse_joint.damping = 0.1;
		PlayState.piece_mouse_joint.frequency = 5;
		PlayState.piece_mouse_joint.space = FlxNapeState.space;
		
		PlayState.dragged_piece = this;
		if (FlxG.mouse.justPressedRight)
		{
			PlayState.drag_right = true;
			body.setShapeFilters(new InteractionFilter(2, 2));
		}
		else
		{
			PlayState.drag_right = false;
			body.setShapeFilters(new InteractionFilter(2, ~2));
		}
		
		Reg.pieces_group.PutOnTop( this );
	}
	
	public function MouseDragStop()
	{
		scale.x = scale.y = 1.0;
		shadow.scale.x = shadow.scale.y = 1.0;
	}
	
	public function IllegalMove()
	{
		x = prev_pos.x;
		y = prev_pos.y;
		body.position.x = x + 22;
		body.position.y = y + 22;
	}
	
	
	private function onMouseOver(Sprite:FlxSprite)
	{
		color = 0xFFFFFF;
	}
	
	private function onMouseOut(Sprite:FlxSprite)
	{
		color = 0xDFDFDF;
	}
	
	override public function update():Void
	{
		super.update();
		
		//if (FlxG.keys.justPressed.ENTER)			trace( pos_board );
		
		
	}
	
	public function UpdateBoardPos()
	{
		var m : FlxPoint = getMidpoint();
			
		if (m.x < Board.board_physical_pos.x)
			m.x = Board.board_physical_pos.x;
			
		if (m.x > Board.board_physical_pos.x + Board.board_physical_size_x())
			m.x = Board.board_physical_pos.x + Board.board_physical_size_x() - 5;
			
		if (m.y < Board.board_physical_pos.y)
			m.y = Board.board_physical_pos.y;
			
		if (m.y > Board.board_physical_pos.y + Board.board_physical_size_y())
			m.y = Board.board_physical_pos.y + Board.board_physical_size_y() - 5;
			
		
		var grid_x : Int = Std.int( (m.x - Board.board_physical_pos.x ) / Board.checker_physical_size );
		var grid_y : Int = Std.int( (m.y - Board.board_physical_pos.y ) / Board.checker_physical_size );
		
		pos_board_x = grid_x;
		pos_board_y = grid_y;
		
		
	}
	
	override public function draw()
	{
		if (dragged)
		{
			shadow.x = x + 5;
			shadow.y = y + 3;
		}
		else
		{
			shadow.x = x + 3;
			shadow.y = y + 2;
		}
		shadow.angle = angle;
		shadow.draw();
		
		super.draw();
		
	}
	
	public function CheckDamka()
	{
		if (is_damka == false && ((player == 0 && pos_board_y == Board.checkers_y-1) ||
			(player == 1 && pos_board_y == 0)) )
		{
			trace("promoted to damka");
			is_damka = true;
			
			if (player == 0)
				animation.frameIndex = 3;
			else
				animation.frameIndex = 7;
		}
	}
	

	override public function destroy():Void
	{
		// Make sure that this object is removed from the MouseEventManager for GC
		MouseEventManager.remove(this);
		super.destroy();
	}
}
