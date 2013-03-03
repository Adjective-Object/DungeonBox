package managedobjs
{
	import org.flixel.*;
	
	public class DebuffHandler
	{
		
		public static var STUN:int = 0;
		public static var GRAVITY_WELL:int = 1;
		public static var BURN:int = 2;
		
		//need on assign and on remove functions too;
		
		public static function applyDebuff(parent:ManagedFlxSprite, debuffID:int):void
		{
			parent.displayDebuffIcon(debuffID,true)
			switch(debuffID){
				case STUN://stunned
					parent.stunned=true;
					break;
				default:
					
				break;
			}
		}
		
		public static function handleDebuff(parent:ManagedFlxSprite, debuffID:int, elapsed:int):void
		{
			switch(debuffID){
				case STUN://stunned
					parent.stunned=true;
					break;
				case BURN://cosmetic, marked to be sucked in by mage R
					if(FlxG.random()<FlxG.elapsed){ parent.damage(1); }
					if(FlxG.random()<FlxG.elapsed){ removeDebuff(parent, BURN); }
					break;
				default:
					
				break;
			}
		}
		
		public static function removeDebuff(parent:ManagedFlxSprite, debuffID:int):void
		{
			parent.displayDebuffIcon(debuffID, false);
			switch(debuffID){
				case STUN://stunned
					parent.stunned=true;
					break;
				case GRAVITY_WELL://cosmetic, marked to be sucked in by mage R
					break;
				default:
					
				break;
			}
		}
		
	}
}