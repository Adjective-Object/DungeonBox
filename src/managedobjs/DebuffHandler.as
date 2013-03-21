package managedobjs
{
	import org.flixel.*;
	
	public class DebuffHandler
	{
		
		public static var STUN:int = 0;
		public static var GRAVITY_WELL:int = 1;
		public static var BURN:int = 2;
		public static var SPARK:int = 3;
		public static var INVULN:int = 4;
		
		//need on assign and on remove functions too;
		
		public static function applyDebuff(parent:ManagedFlxSprite, debuffID:int):void
		{
			parent.displayDebuffIcon(debuffID,true)
			switch(debuffID){
			}
		}
		
		public static function handleDebuff(parent:ManagedFlxSprite, debuffID:int):void
		{
			switch(debuffID){
				case STUN://stunned
					break;
				case BURN://cosmetic, marked to be sucked in by mage R
					if (FlxG.random() * 1.0< FlxG.elapsed) { parent.damage(1); }
					if (FlxG.random() * 3.0< FlxG.elapsed) { parent.removeDebuff(BURN); }
					break;
				default:
					
					break;
			}
		}
		
		public static function removeDebuff(parent:ManagedFlxSprite, debuffID:int):void
		{
			parent.displayDebuffIcon(debuffID, false);
			switch(debuffID){
				default:
					
				break;
			}
		}
		
	}
}