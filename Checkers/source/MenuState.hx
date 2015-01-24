package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
using flixel.util.FlxSpriteUtil;

class MenuState extends FlxState
{
	
	override public function create():Void
	{
		super.create();
	
		SetupMouseCursor();
		
		add(new FlxText(100, 100, 100, "Hello, World!", 12));
		
	}
	
	function SetupMouseCursor():Void
	{
		/*
		var sprite = new FlxSprite();
		sprite.makeGraphic(12, 12, FlxColor.TRANSPARENT);
		sprite.drawCircle();

		// Load the sprite's graphic to the cursor
		FlxG.mouse.load(sprite.pixels);*/

		// Use the default mouse cursor again
		//FlxG.mouse.unload();

		// To use the system cursor:
		FlxG.mouse.useSystemCursor = true;	
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
	}	
}