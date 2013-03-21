package HUDItems
{
	import org.flixel.*;
	
	public class HUDText extends FlxText
	{
		protected var screenOff:FlxPoint ;
		protected var elapsed:Number = 0, lifetime:Number;
		
		public function HUDText(x:int, y:int, width:int, text:String, lifetime:Number = -1, align:String = "left")
		{
			super(FlxG.width/2/FlxG.camera.zoom+x, FlxG.height/2/FlxG.camera.zoom+y,width,text);
			this.scrollFactor.x=this.scrollFactor.y=0;
			screenOff = new FlxPoint(x,y);
			this.lifetime=lifetime;
			this.alignment=align;
		}
		
		public override function update():void{
			super.update();
			this.elapsed+= FlxG.elapsed;
			if(lifetime!=-1 && this.elapsed>this.lifetime){
				this.kill();
			}
		}
	}
}