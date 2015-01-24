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
	public var posBoard : FlxPoint; // 0 based
	
	
	public var player : Int;  // 0 or 1
	

	public function new(X:Int, Y:Int, OffsetX:Int, OffsetY:Int):Void
	{
		super(X + OffsetX, Y + OffsetY);
		loadGraphic("assets/images/pieces.png", true, 44, 44);
		
	
		animation.frameIndex = FlxRandom.intRanged(0, 6);
		// So the card still looks smooth when rotated
		antialiasing = true;
		setDrag(0.3, 0.3);
	
		//createRectangularBody(79, 123);
		createCircularBody(16);
		
		// To make sure cards don't interact with each other
		//body.setShapeFilters(new InteractionFilter(2, ~2));
		
		// Setup the mouse events
		MouseEventManager.add(this, onDown, null, onMouseOver, onMouseOut);
	}
	
	private function onDown(Sprite:FlxSprite)
	{
		var body:Body = cast(Sprite, FlxNapeSprite).body;
		
		PlayState.cardJoint = new DistanceJoint(FlxNapeState.space.world, body, Vec2.weak(FlxG.mouse.x, FlxG.mouse.y), body.worldPointToLocal(Vec2.weak(FlxG.mouse.x, FlxG.mouse.y)), 0, 0);
		PlayState.cardJoint.stiff = false;
		PlayState.cardJoint.damping = 0.1;
		PlayState.cardJoint.frequency = 5;
		PlayState.cardJoint.space = FlxNapeState.space;
	}
	
	
	private function onMouseOver(Sprite:FlxSprite) 
	{
		color = 0xFFFFFF;
	}
	
	private function onMouseOut(Sprite:FlxSprite)
	{
		color = 0xDFDFDF;
	}
	
	//private function pickCard(Tween:FlxTween):Void
	//{
		//// Choose a random card from the first 52 cards on the spritesheet 
		//// - excluding those who have already been picked!
		//animation.frameIndex = FlxRandom.intRanged(0, 51);
	//}
	
	override public function destroy():Void 
	{
		// Make sure that this object is removed from the MouseEventManager for GC
		MouseEventManager.remove(this);
		super.destroy();
	}
}
