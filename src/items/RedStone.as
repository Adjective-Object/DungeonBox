package items
{
	import org.flixel.FlxG;
	import managers.Manager;
	import managedobjs.MSLib;
	import managedobjs.PlayerControlled;
	
	public class RedStone extends Item
	{
		public static var IMType = 1;
		
		protected static var damageValue = 3;
		protected static var range = 100;
		protected static var cooldownHit = 5;
		protected static var cooldownMiss = 2;
		
		protected var elapsed=0;
		
		[Embed(source = "/../res/RedRock.png")] private var RedStoneImage:Class;
		
		public function RedStone()
		{
			this.type = RedStone.IMType;
			this.image=RedStoneImage;
			this.isUseItem=true;
			this.description = "damage in large AOE";
		}
		
		public override function onUse(){
			var hit:Boolean = false;
			for each(var gameObject:ManagedFlxSprite in this.owner.parent.getAllSprites().members){
				if(gameObject!=null && gameObject.align!=this.owner.align && gameObject.align!=Manager.align_none && MSLib.distance(this.owner,gameObject)<RedStone.range){
					gameObject.damage(RedStone.damageValue);
					hit=true;
				}
			}
			if(hit){
				(PlayerControlled)(this.owner).cooldowns[4]=cooldownHit;
			} else{
				(PlayerControlled)(this.owner).cooldowns[4]=cooldownMiss;
			}
		}

	}
}