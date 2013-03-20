package items
{
	import org.flixel.FlxG;
	import managers.Manager;
	public class RedStone extends Item
	{
		public static var IMType = 1;
		
		protected static var healCharge = 1;
		protected static var healDelay = 0.5;
		protected static var healValue = 1;
		
		protected var elapsed=0;
		
		[Embed(source = "/../res/RedRock.png")] private var RedStoneImage:Class;
		
		public function RedStone()
		{
			this.type = RedStone.IMType;
			this.image=RedStoneImage;
			this.isUseItem=true;
		}
		
		public override function onUse(){
			this.owner.damage(-10);
			this.owner.cooldowns[4]=10;
		}

	}
}