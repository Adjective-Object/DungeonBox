package
{
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	
	public class DamageText extends FlxText
	{
		
		protected var elapsed:Number = 0;
		protected static var lifetime:Number = 0.55;
		
		public function DamageText(x:Number, y:Number, value:int, allign:int)
		{
			super(x,y,30,value.toString());
			if (value > 0) {
				if(allign == Manager.align_friend){
					this.color = 0xffff0000;
				}
				else {//enemy
					this.color = 0xffdd11dd;
				}
			} else if(value==0){
				this.color = 0xffffffff;
				this.text = "miss";
			} else{
				this.color = 0xf00fff00;
				this.text = (-value).toString();
			}
		}
		
		public override function update():void {
			elapsed+=FlxG.elapsed;
			this.alpha = (DamageText.lifetime-elapsed)/DamageText.lifetime;
			if(elapsed>DamageText.lifetime){
				this.kill();
			}
		}
		
	}
}