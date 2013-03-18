package managers  
{
	import flash.utils.Dictionary;
	
	import org.flixel.FlxGroup;
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
		public var mapSize:FlxPoint;
		
		//What are more or less networking constants
		public static var event_spawn:int = 0;
		//spawn a nonplayer sprite.
		//args (ID, X, Y, TYPE, align, facing)
		public static var event_update_position:int = 1;
		//update nomplayer sprite.
		//args (ID, X, Y)
		public static var event_damage:int = 2
		//tells client that nonplayer sprite has died
		//args (ID, damage)
		public static var event_kill:int = 3
		//tells client that nonplayer sprite has died
		//args (ID)
		public static var event_update_health:int = 4;
		//update nomplayer sprite.
		//args (ID, HP)
		public static var event_update_animation:int = 5;
		//update nomplayer sprite.
		//args (ID, ANIMATION, facing)
		//ANIMATION is a 4 character string that denotes the animation.
		public static var event_knockback:int = 6
		//knocks back a thing
		//args (ID targeted, ID attacker, knockbackval)
		public static var event_debuff:int = 7
		//debuffs a thing
		//args (ID targeted, ID debuff, on/off)
		
		public static var msgConfigs = ["iiiiii", "iii", "ii", "i", "ii", "isi", "iii", "iii"];
		
		public var clientSide:Boolean = false;
		
		public static var align_friend:int = 1;
		public static var align_enemy:int = 0;
		
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
		
		public function getAllSprites():FlxGroup
		{
			return new FlxGroup();
		}
		
		public function getPlayers():Array { return new Array(); }
		public function getEntity( id:uint):ManagedFlxSprite{return null;}
		
		public function spawn( e:ManagedFlxSprite):void {}
		public function updatePosition( e:ManagedFlxSprite):void {}
		public function updateHealth( e:ManagedFlxSprite):void {}
		public function updateAnimation( e:ManagedFlxSprite):void {}
		public function kill( e:ManagedFlxSprite):void {}
		public function damage( e:ManagedFlxSprite, damage:int ):void {}
		public function knockBack( e:ManagedFlxSprite, x:int, y:int ):void {}
		public function applyDebuff( e:ManagedFlxSprite, debuffID:int ):void {}
		public function removeDebuff( e:ManagedFlxSprite, debuffID:int ):void {}
		
		public static function getSpawnEvent(p:ManagedFlxSprite):Array {
			return new Array( Manager.event_spawn, p.managedID, (int)(p.x), (int)(p.y), p.type, p.align, p.facing);
		}
		public static function getDamageEvent(p:ManagedFlxSprite, damage:int):Array {
			return new Array( Manager.event_damage, p.managedID, damage);
		}
		public static function getUpdatePosEvent(p:ManagedFlxSprite):Array {
			return new Array( Manager.event_update_position, p.managedID, (int)(p.x), (int)(p.y) );
		}
		public static function getUpdateHPEvent(p:ManagedFlxSprite):Array {
			return new Array( Manager.event_update_health, p.managedID, p.health );
		}
		public static function getUpdateAnimEvent(p:ManagedFlxSprite):Array {
			return new Array( Manager.event_update_animation, p.managedID, p.oldanimname, p.facing);
		}
		public static function getKillEvent(p:ManagedFlxSprite):Array {
			return new Array( Manager.event_kill, p.managedID);
		}
		public static function getKnockbackEvent(target:ManagedFlxSprite, x:int, y:int ):Array {
			return new Array( Manager.event_knockback, target.managedID, x, y);
		}
		public static function getDebuffEvent(target:ManagedFlxSprite, debuffID:int ):Array {
			return new Array( Manager.event_debuff, target.managedID, debuffID, 1);
		}
		public static function getDebuffClearEvent(target:ManagedFlxSprite, debuffID:int ):Array {
			return new Array( Manager.event_debuff, target.managedID, debuffID, 0);
		}
		
	}
}