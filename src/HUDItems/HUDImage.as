package HUDItems
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class HUDImage extends FlxSprite
	{
		protected var screenOff:FlxPoint;
		
		public function HUDImage(x:int, y:int, image:Class)
		{
			super(FlxG.width/2/FlxG.camera.zoom+x, FlxG.height/2/FlxG.camera.zoom+y);
			this.loadGraphic(image);
			screenOff = new FlxPoint(x,y);	
		}
	}
}