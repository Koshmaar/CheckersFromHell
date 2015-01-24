package;

import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxRandom;
import nape.constraint.DistanceJoint;
import nape.geom.Vec2;
import flixel.util.FlxMath;


class PlayState extends FlxNapeState
{
	public static var cardJoint:DistanceJoint;
	
	private var _cardGroup:FlxTypedGroup<Piece>;
	private var _fan:FlxSprite;
	
	override public function create():Void 
	{
		super.create();
		
		// A table as a background
		add(new FlxSprite(0, 0, "assets/images/board.png"));
				
		// Important to set this up before createCards()
		FlxG.plugins.add(new MouseEventManager());
		
		// Creating the card group and the cards
		_cardGroup = new FlxTypedGroup<Piece>();
		setPiecesOnBoard();
		add(_cardGroup);

		napeDebugEnabled = false;
		createWalls();
		
		/*_fan = new FlxSprite(340, -280, "assets/fan.png");
		_fan.antialiasing = true;
		// Let the fan spin at 10 degrees per second
		_fan.angularVelocity = 10;
		add(_fan);*/
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		cardJoint = null;
		_cardGroup = null;
		_fan = null;
	}
	
	private function setPiecesOnBoard() 
	{
		
		for (i in 0...5)
		{
			var card:Piece = new Piece(40, 340, 70 * i, 0);
			_cardGroup.add(card);
		}
		
		
		for (i in 0...5)
		{
			var card:Piece = new Piece(40, 50, 70 *i, 0);
			_cardGroup.add(card);
		}
	}
	
	
	// for easy piece setting:
	public function Debug() : Void
	{
		// if key pressed
		// trace mouse pos
		
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (cardJoint != null)
		{
			cardJoint.anchor1 = Vec2.weak(FlxG.mouse.x, FlxG.mouse.y);
		}
		
		// Remove the joint again if the mouse is not down
		if (FlxG.mouse.justReleased)
		{
			if (cardJoint == null)
			{
				return;
			}
			
			cardJoint.space = null;
			cardJoint = null;
		}
		
		// Keyboard hotkey to reset the state
		if (FlxG.keys.pressed.R)
		{
			FlxG.resetState();
		}
	}
}