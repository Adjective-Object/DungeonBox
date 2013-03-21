package items
{
	import org.flixel.FlxG;
	import managers.Manager;
	
	import managedobjs.PlayerControlled;
	
	public class GreenStone extends Item
	{
		public static var IMType = 2;
		
		protected static var healValue = 10;
		protected static var cooldown = 10;
		
		
		protected var elapsed=0;
		
		[Embed(source = "/../res/GreenRock.png")] private var GreenstoneImage:Class;
		
		public function GreenStone()
		{
			this.type = GreenStone.IMType;
			this.image=GreenstoneImage;
			this.isUseItem=true;
			this.description = "large self heal";
		}
		
		public override function onUse(){
			this.owner.damage(-healValue);
			(PlayerControlled)(this.owner).cooldowns[4] = GreenStone.cooldown;
		}

	}
}