package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	import managedobjs.*;
	
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Maxwell Huang-Hobbs
	 */
	public class LocalManager extends Manager
	{	
		protected var objectMap:Dictionary = new Dictionary();//dictionary of server-handled object
		protected var playerOne:ManagedFlxSprite;
		protected var playerTwo:ManagedFlxSprite;
		
		protected static var numPlayers:int = 2;
		
		protected var gameEvents:Array = new Array();
		protected var parsedEvents:Array = new Array();
		protected var idCounter:int;

		public function LocalManager( clientSide:Boolean = false) 
		{
			this.clientSide = clientSide;
			
			this.idCounter = 0;
			
			this.mapSize = new FlxPoint(PlayState.data[0].length * 32, PlayState.data.length * 32);
			
			this.playerOne = new Player(mapSize.x / 2 - 50, mapSize.y / 2, this, idCounter);
			this.playerOne.spawn();
			
			/* TODO spawning player 2, reporting players as diff. entity types to diff clients
			this.playerTwo =  new Player(mapSize.x / 2 + 50, mapSize.y / 2, this, idCounter);
			this.playerTwo.spawn();
			*/
			super();
		}
		
		/**
		 * updates each of the sprites in the game, reporting the events that happen as a result
		 * 
		 * Also advances game logic
		 */
		override public function update():void
		{
			super.update();
			
			while (this.gameEvents.length > 0) {//implementing incoming events on entities
				var temp:Array = gameEvents.splice(0, 1)[0];
				parseEvent(temp);
			}
			
			//updating each entity
			for each( var gameObject:ManagedFlxSprite in objectMap)
			{
				gameObject.update();
				gameObject.postUpdate();
			}
			
			//TODO game logic (enemy spawning, etcetera) goes here, instead of this random ass random
			
			if (FlxG.random() < 0.01)
			{
				var f:ExampleEnemy = new ExampleEnemy((mapSize.x-11) * FlxG.random(), (mapSize.y-15) * FlxG.random(), this, idCounter);
				f.spawn();
			}
		}
		
		override public function reportEvent( event:Array ):void
		{
			//trace(event);
			this.gameEvents.push(event);
		}
		
		/**
		 * pushes event to clients w/o parsing it in the local manager
		 * @param	event
		 */
		protected function pushEvent( event:Array ):void
		{
			//trace(event);
			this.parsedEvents.push(event);
		}
		
		override public function getGameEvent():Array {
			//returns first element in gameEvents
			if (parsedEvents.length > 0) {
				var p:Array = parsedEvents.splice(0, 1)[0];
				return p;//remove and return first element
			}
			return null;
		}
		
		override public function getPlayer():ManagedFlxSprite
		{
			return this.playerOne;
		}
		
		protected function parseEvent(args:Array):void
		{
			var type = args[0]
			switch(type) 
			{
				case Manager.event_spawn:
					this.objectMap[args[1]] = makeGameSprite(args[1], args[2], args[3], args[4])
				break;
				case Manager.event_update_position:
					this.objectMap[args[1]].x = args[2];
					this.objectMap[args[1]].y = args[3];
				break;
				case Manager.event_update_health:
					this.objectMap[args[1]].hp = args[2];
				break;
				
				default:
				break;
			}
		}	
		
		protected function makeGameSprite(id:int, x:int, y:int, MSID:int ):ManagedFlxSprite {
			var f:ManagedFlxSprite = MSLib.getMFlxSprite(MSID, x, y, this, id)
			return f
		}
		
		public override function getEntity( id:uint):ManagedFlxSprite
		{
			return this.objectMap[id];
		}
		
		public override function spawn( e:ManagedFlxSprite ):void
		{
			this.objectMap[idCounter] = e;
			idCounter++;
			this.pushEvent( new Array( Manager.event_spawn, e.managedID, e.x, e.y, e.type) );
		}
		
		public override function updatePosition( e:ManagedFlxSprite):void
		{
			this.pushEvent( new Array( Manager.event_update_position, e.managedID, e.x, e.y) );
		}
		
		public override function updateHealth( e:ManagedFlxSprite):void
		{
			this.pushEvent( new Array( Manager.event_update_health, e.managedID, e.x, e.y) );
		}
		
		public override function kill( e:ManagedFlxSprite):void
		{
			this.pushEvent( new Array( Manager.event_kill, e.managedID) );
			delete this.objectMap[e.managedID];
		}
		
		public static function countKeys(myDictionary:flash.utils.Dictionary):int 
		{		
			var n:int = 0;
			for (var key:* in myDictionary) {
				n++;
			}
			return n;
		}
		
	}
}