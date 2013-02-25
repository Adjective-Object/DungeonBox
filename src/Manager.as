package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * An Essentially abstract class that manages nonplayer sprites
	 * (other player counts as nonplayer)
	 * 
	 * @author Maxwell Huang-Hobbs
	 */
	public class Manager
	{
		//game variables
		public static var mapSize:FlxPoint = new FlxPoint(500,500);
		
		//What are more or less networking constants
		public static var event_spawn:int = 0;
		//spawn a nonplayer sprite.
		//args (ID, X, Y, TYPE)
		public static var event_update_position:int = 1;
		//update nomplayer sprite.
		//args (ID, X, Y)
		public static var event_update_health:int = 4;
		//update nomplayer sprite.
		//args (ID, HP)
		public static var event_update_animation:int = 5;
		//update nomplayer sprite.
		//args (ID, ANIMATION)
		//ANIMATION is a 4 character string that denotes the animation.
		public static var event_damage:int = 2
		//tells client that nonplayer sprite has died
		//args (ID, damage)
		public static var event_kill:int = 3
		//tells client that nonplayer sprite has died
		//args (ID)
		
		public var clientSide:Boolean = false;
		
		public function Manager(){}
		
		/**
		 * updates each of the sprites in the game, reporting the events that happen as a result
		 */
		public function update():void {}
		
		/**
		 * returns game event
		 * if there is a game event to report, returns Array( type,  args )
		 * 
		 * if there is not a game event to report, returns null
		 */
		public function getGameEvent():Array
		{
			return null;
		}
		
		/**
		 * tells the manager of stuff happening in the PlayState.
		 */
		public function reportEvent( event:Array ):void
		{
			
		}
		
		/**
		 * tells the PlayState the sprite it is in control of.
		 * 
		 * @return the player FlxSprite
		 */
		public function getPlayer():FlxSprite
		{
			return null
		}
	}
}