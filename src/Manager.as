package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	import flash.utils.Dictionary;
	
	/**
	 * An Essentially abstract class that manages nonplayer sprites
	 * (other player counts as nonplayer)
	 * 
	 * @author Maxwell Huang-Hobbs
	 */
	public class Manager
	{
		//game variables
		public var mapSize:FlxPoint;
		
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
		 * will do nothing on networked version
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
		
		public function getAllSprites():Dictionary
		{
			return new Dictionary();
		}
		
		/**
		 * tells the PlayState the sprite it is in control of.
		 * 
		 * @return the player FlxSprite
		 */
		public function getPlayer():ManagedFlxSprite{return null}
		public function getEntity( id:uint):ManagedFlxSprite{return null;}
		
		public function spawn( e:ManagedFlxSprite):void {}
		public function updatePosition( e:ManagedFlxSprite):void {}
		public function updateHealth( e:ManagedFlxSprite):void {}
		public function kill( e:ManagedFlxSprite):void {}
		public function damage( e:ManagedFlxSprite, damage:int ):void {}
		
		public static function getDamageEvent(p:ManagedFlxSprite, damage:uint):Array {
			return new Array( Manager.event_damage, p.managedID, damage)
		}
		public static function getSpawnEvent(p:ManagedFlxSprite):Array {
			return new Array( Manager.event_spawn, p.managedID, p.x, p.y, p.type);
		}
		public static function getUpdatePosEvent(p:ManagedFlxSprite):Array {
			return new Array( Manager.event_update_position, p.managedID, p.x, p.y);
		}
		public static function getUpdateHPEvent(p:ManagedFlxSprite):Array {
			return new Array( Manager.event_update_health, p.managedID, p.health);
		}
		public static function getKillEvent(p:ManagedFlxSprite):Array {
			return new Array( Manager.event_kill, p.managedID);
		}
		
	}
}