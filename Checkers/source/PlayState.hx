package;

import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import nape.constraint.DistanceJoint;
import nape.geom.Vec2;
import flixel.util.FlxMath;


class PlayState extends FlxNapeState
{
	public static var piece_mouse_joint:DistanceJoint;
	
	//private var _fan:FlxSprite;
	
	override public function create():Void 
	{
		super.create();
		
		add(new FlxSprite(0, 0, "assets/images/board.png"));
				
		// call before setPiecesOnBoard
		FlxG.plugins.add(new MouseEventManager());
		
		Reg.pieces_group = new FlxTypedGroup<Piece>();
		setPiecesOnBoard();
		add(Reg.pieces_group);

		napeDebugEnabled = false;
		createWalls();
		
		/*_fan = new FlxSprite(340, -280, "assets/fan.png");
		_fan.antialiasing = true;
		// Let the fan spin at 10 degrees per second
		_fan.angularVelocity = 10;
		add(_fan);*/
		
		new FlxTimer(16.0, ChangeRules, 0);
		
		#if !debug
		FlxG.sound.playMusic("assets/music/Spinning_Clocks-Silver_UFOs.mp3");
		#end
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		piece_mouse_joint = null;
		Reg.pieces_group = null;
		//_fan = null;
	}
	
	private function setPiecesOnBoard() 
	{


		Reg.board.Init();
		
		var polish_offset_x : Int = 0;
		var polish_offset_y : Int = -5;
		
			
		//AddPieceRow( 1, 0, Reg.board.GetPieceType(0) );
		// black
		
		// first row
		for (i in 0...4)
		{
			AddPieceRow( i*2, 0, Reg.board.GetPieceType(0) );
		}
		// second 
		for (i in 0...4)
		{
			AddPieceRow( i*2 + 1, 1, Reg.board.GetPieceType(0) );
		}
		// third
		for (i in 0...4)
		{
			AddPieceRow( i*2, 2, Reg.board.GetPieceType(0) );
		}
		
		
		// red
		for (i in 0...4)
		{
			AddPieceRow( 1 + i*2, 9, Reg.board.GetPieceType(1) );
		}
		for (i in 0...4)
		{
			AddPieceRow( i*2, 8, Reg.board.GetPieceType(1) );
		}
		for (i in 0...4)
		{
			AddPieceRow( 1 + i*2, 7, Reg.board.GetPieceType(1) );
		}
	}
	
	public function AddPieceRow( x : Int, y : Int , type : Int )
	{
		var c : Checker = Reg.board.the[x][y];
		var m : FlxPoint = c.getMidPoint();
		
		var p:Piece = new Piece( m.x , m.y , type);
		p.pos_board_x = x ;
		p.pos_board_y = y;
		Reg.pieces_group.add(p);
		
	}
	
	static public var dragged_piece : Piece;
	static public var drag_right : Bool; // true if started with right mosue button
	
	static public function mouse_any_just_released()
	{
		return FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight;
	}
	
	static public function mouse_any_just_pressed()
	{
		return FlxG.mouse.justPressed || FlxG.mouse.justPressedRight;
	}
	
	//static public function mouse_any_()
	//{
		//return FlxG.mouse.justPressed || FlxG.mouse.justPressedRight;
	//}
	
	public function UpdateMouseJoint():Void
	{
		if (piece_mouse_joint != null)
		{
			piece_mouse_joint.anchor1 = Vec2.weak(FlxG.mouse.x, FlxG.mouse.y);
			//trace("dragging");
		}
				
		if (mouse_any_just_released())
		{
			if (piece_mouse_joint == null)
			{
				return;
			}
			
			dragged_piece.UpdateBoardPos();
			
			var c : Checker = Reg.board.the[ dragged_piece.pos_board_x][dragged_piece.pos_board_y ];
			
			if ( !c.legal )
			{
				dragged_piece.x = dragged_piece.prev_pos.x;
				dragged_piece.y = dragged_piece.prev_pos.y;
				dragged_piece.body.position.x = dragged_piece.x + 22;
				dragged_piece.body.position.y = dragged_piece.y + 22;
			}

				dragged_piece.prev_pos.x = dragged_piece.x;
				dragged_piece.prev_pos.y = dragged_piece.y;
			dragged_piece.UpdateBoardPos();
			
			
			trace("!! Mouse.released");
			piece_mouse_joint.space = null;
			piece_mouse_joint = null;
			
			dragged_piece = null;
			
			
		}
	}
	
	public function ChangeRules(Timer: FlxTimer) : Void
	{
		//trace("Rules have changed to...");
		
		var rules : Array<String> = [ "1111111111",  "2222222", "3333" ];
		var rand : Int = FlxRandom.intRanged(0, 2);
		
		//trace( rules[ rand ] );
		
		
	}
	
	
	override public function update():Void 
	{
		super.update();
		
		UpdateMouseJoint();
		
		Reg.board.CheckPiecesPositions();
		
		
		#if debug
			Debug();
		#end
		
	}
	
	override public function draw():Void 
	{
		super.draw();
		
		Reg.board.draw();
	}
	
	
	public function Debug() : Void
	{
		
		if (FlxG.keys.justPressed.SPACE)
			trace( FlxG.mouse.getScreenPosition() );
				
				
		if (FlxG.keys.pressed.R)
		{
			FlxG.resetState();
		}
		
	}

	
}