package HUDItems
{
	import org.flixel.*;
	
	public class HUDText extends FlxText
	{
		protected var screenOff:FlxPoint ;
		
		public function HUDText(x:int, y:int, width:int, text:String)
		{
			super(FlxG.width/2/FlxG.camera.zoom+x, FlxG.height/2/FlxG.camera.zoom+y,width,text);
			this.scrollFactor.x=this.scrollFactor.y=0;
			screenOff = new FlxPoint(x,y);	
		}
	}
}