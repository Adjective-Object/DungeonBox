package managedobjs
{
	import org.flixel.*;
	
	public class DebuffHandler
	{
		
		[Embed(source = "/../res/Mage.png")] private var gravityGraphic:Class;
		
		//need on assign and on remove functions too;
		
		public static function handleDebuff(parent:ManagedFlxSprite, id:int, elapsed:int):void
		{
			switch(id){
				case 0://stunned
					parent.stunned=true;
				break;
				case 1://cosmetic, marked to be sucked in by mage R
					parent.attachedSprites.push(new FlxSprite(0,0,gravityGraphic));
					break;
				default:
					
				break;
			}
		}
		
	}
}