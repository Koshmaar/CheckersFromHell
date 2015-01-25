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
	public var pos_board : FlxPoint = new FlxPoint(); // 0 based
	
	
	public var player : Int = 0;  // 0 for black, 1 for red
	

	public function new(X: Float, Y: Float, type : Int):Void
	{
		super(X , Y );
		loadGraphic("assets/images/pieces.png", true, 44, 44);
		
	
		//animation.frameIndex = FlxRandom.intRanged(0, 6);
		animation.frameIndex = type;
		
		if (type >= 4)
			player = 1;
		
		antialiasing = true;
		setDrag(0.3, 0.3);
	
		//createRectangularBody(79, 123);
		createCircularBody(18);
		
		// To make pieces don't interact with each other
		//body.setShapeFilters(new InteractionFilter(2, ~2));
		
		// Setup the mouse events
		MouseEventManager.add(this, onDown, null, onMouseOver, onMouseOut);
	}
	
	private function onDown(Sprite:FlxSprite)
	{
		var body:Body = cast(Sprite, FlxNapeSprite).body;
		
		PlayState.piece_mouse_joint = new DistanceJoint(FlxNapeState.space.world, body, Vec2.weak(FlxG.mouse.x, FlxG.mouse.y), body.worldPointToLocal(Vec2.weak(FlxG.mouse.x, FlxG.mouse.y)), 0, 0);
		PlayState.piece_mouse_joint.stiff = false;
		PlayState.piece_mouse_joint.damping = 0.1;
		PlayState.piece_mouse_joint.frequency = 5;
		PlayState.piece_mouse_joint.space = FlxNapeState.space;
	}
	
	
	private function onMouseOver(Sprite:FlxSprite) 
	{
		color = 0xFFFFFF;
	}
	
	private function onMouseOut(Sprite:FlxSprite)
	{
		color = 0xDFDFDF;
	}
	

	override public function destroy():Void 
	{
		// Make sure that this object is removed from the MouseEventManager for GC
		MouseEventManager.remove(this);
		super.destroy();
	}
}
