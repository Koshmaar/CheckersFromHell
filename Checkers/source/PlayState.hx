package;

import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.plugin.MouseEventManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import nape.constraint.DistanceJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import flixel.util.FlxMath;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;


class PlayState extends FlxNapeState
{
	public static var piece_mouse_joint:DistanceJoint;
	
	//private var _fan:FlxSprite;
	
	public var text : FlxText;
	
	public var moves_black : FlxText;
	public var moves_red : FlxText;
	
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
		
		FlxG.stage.scaleMode = StageScaleMode.SHOW_ALL;
		FlxG.stage.align = StageAlign.TOP; // centers it horizontally
		//FlxG.stage.scaleMode = StageScaleMode.SHOW_ALL
		
		FlxG.camera.antialiasing = true;
		
		
		text = new FlxText(20, FlxG.height - 70, FlxG.width-30, "What Do We Do Now ?");
		text.setFormat("assets/cheri.ttf", 38, FlxColor.BLACK, "center");
		//text.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.WHITE, 2);
		//text.addFormat(new FlxTextFormat(0xE6E600, false, false, 0xFF8000, 0, -1));
		add(text);
		
		
		moves_black = new FlxText(FlxG.width - 50, 90, 60, "0");
		moves_black.setFormat("assets/cheri.ttf", 32, FlxColor.BLACK, "center");
		add(moves_black);
		
		moves_red = new FlxText(FlxG.width - 50, 620, 60, "0");
		moves_red.setFormat("assets/cheri.ttf", 32, FlxColor.BLACK, "center");
		add(moves_red);
		
		//myText.setFormat("assets/font.ttf", 20, FlxColor.WHITE, "center");
		
		rules_timer = new FlxTimer(16.0, ChangeRules, 0);
		
		#if !debug
		FlxG.sound.playMusic("assets/music/Spinning_Clocks-Silver_UFOs_compressed.mp3");
		#end
	}
	
	private var rules_timer : FlxTimer;
	
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
				dragged_piece.IllegalMove();
				trace("illegal pos");
			}
			else
			{
				if (CheckKill( dragged_piece ))
				{
					moved_counts[ dragged_piece.player ] ++;
				}
			}

			dragged_piece.prev_pos.x = dragged_piece.x;
			dragged_piece.prev_pos.y = dragged_piece.y;
			dragged_piece.prev_pos_board_x = dragged_piece.pos_board_x;
			dragged_piece.prev_pos_board_y = dragged_piece.pos_board_y;
			
			dragged_piece.UpdateBoardPos();
			dragged_piece.CheckDamka();
			
			dragged_piece.body.setShapeFilters(new InteractionFilter(2, 2));
			
			trace("!! Mouse.released");
			piece_mouse_joint.space = null;
			piece_mouse_joint = null;
			
			
			moves_black.text = moved_counts[0] + ""; 
			moves_red.text = moved_counts[1] + ""; 
			
			dragged_piece.MouseDragStop();
			
			dragged_piece = null;
			
		}
	}
	
	public function CheckKill( p : Piece ) : Bool
	{
		trace( "start " + p.prev_pos_board_x + ", " + p.prev_pos_board_y );
		trace( "end " + p.pos_board_x + ", " + p.pos_board_y );
		
		var dir_x : Int = p.pos_board_x - p.prev_pos_board_x;
		var dir_y : Int = p.pos_board_y - p.prev_pos_board_y;
		
		trace( " dir " + dir_x + ", " + dir_y );
		
		var long_move : Bool = Math.abs(dir_x) > 2 || Math.abs(dir_y) > 2;
		
		var diagonal_move : Bool = Math.abs(dir_x) == Math.abs(dir_y);
		
		if ( current_rule == 1) // now kills forward legal
		{
			if ( Math.abs( dir_x ) > Math.abs( dir_y ) )
			{
				p.IllegalMove();
				trace("not sideways");
				return false;
			}
		}
		else
		{
			if (!diagonal_move)
			{
				p.IllegalMove();
				trace("not diagonal");
				return false;
			}
		}
		
		if (dir_x == 0 && dir_y == 0) 
		{
			// hack, but not so bad - this way this move won't be counted
			moved_counts[ dragged_piece.player ] --;
			return true;
		}
		
		if ( long_move && !p.is_damka )
		{
			p.IllegalMove();
			trace("illegal move");
			return false;
		}
		
		
		if (long_move)
		{
			
			
		}
		else // pion
		{
			
			var killing_move : Bool = Math.abs(dir_x) == 2 && Math.abs(dir_y) == 2;
			
			if (killing_move ) // length 2
			{
				var jumped_over_x : Int = p.pos_board_x - Std.int( dir_x / 2 );
				var jumped_over_y : Int = p.pos_board_y - Std.int( dir_y / 2 );
				
				trace( "j " + jumped_over_x + ", " + jumped_over_y );
				
				if (jumped_over_x == p.pos_board_x && jumped_over_y == p.pos_board_y)
				{
					trace(" jumped over self ?");
					return false;
				}
				
				var b : Array< Array<Checker> > = Reg.board.the;
				
				var e : Piece = Reg.board.GetPieceOnChecker( jumped_over_x, jumped_over_y);
				
				if (e != null)
				{
					if (e.player == p.player)
					{
						trace("can't kill own pieces");
						p.IllegalMove();
						return false;
					}
					
					trace("killed " + e );
					e.kill();
				}
				else
				{
					trace("can move only by one field when not killing");
					p.IllegalMove();
					return false;
				}
				
			}
			else // length 1
			{
				var e : Piece = Reg.board.IsOtherOnChecker( p.pos_board_x, p.pos_board_y, p);
				if (e != null)
				{
					trace("checker holden");
					p.IllegalMove();
					return false;
				}	
			}
		}
		
		
		/*var i_x = [ -1, 1 ];
		var i_y = [ -1, 1 ];
		for (x in i_x)
		{
			for (y in i_y)
			{
				var e : Piece = Reg.board.GetPieceOnChecker( p.pos_board_x + x, p.pos_board_y + y);
		
				if (e != null)
				{
					e.kill();
				}
			}
		}*/
		
		return true;		
	}
	
	public function ChangeRules(Timer: FlxTimer) : Void
	{
		//trace("Rules have changed to...");
		
		var rules : Array<String> = [ "Only move checkers back",  "move forward legal", "move opponents checker" ];
		var rand : Int = FlxRandom.intRanged(0, 2);
		current_rule = rand;
		
		text.text = rules[ current_rule ] ;
		
		FlxG.camera.flash();
		
		//trace( rules[ rand ] );
		
	}
	
	public var current_rule : Int = -1;
	
	public var moved_counts = [ 0, 0 ];
	
	
	override public function update():Void 
	{
		super.update();
		
		UpdateMouseJoint();
		
		Reg.board.CheckPiecesPositions();
		
		if (FlxG.keys.justPressed.SPACE)
		{
			ChangeRules(rules_timer);
			rules_timer.reset(16);
		}
		
		if (FlxG.keys.pressed.R)
		{
			FlxG.resetState();
		}
		
		#if debug
			Debug();
		#end
		
	}
	
	override public function draw():Void 
	{
		super.draw();
		
		//Reg.board.draw();
	}
	
	
	public function Debug() : Void
	{
		
		if (FlxG.keys.justPressed.SPACE)
			trace( FlxG.mouse.getScreenPosition() );
		
		
	}

	
}