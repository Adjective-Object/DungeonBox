package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	import managedobjs.MSLib;
	
	import managedobjs.Player;
	
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
			
			this.playerOne = new Player(mapSize.x / 2 - 50, mapSize.y / 2, this, idCounter);
			this.playerOne.spawn();
			idCounter++;
			/* TODO spawning player 2, reporting players as diff. entity types
			this.playerTwo =  new Player(mapSize.x / 2 + 50, mapSize.y / 2, this, idCounter);
			this.playerTwo.spawn();
			idCounter++;
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
			
			while (this.gameEvents.length > 0) {//implementing events on entities
				var temp:Array = gameEvents.splice(0, 1)[0];
				parseEvent(temp);
				parsedEvents.push(temp)
			}
			
			//updating each entity
			for each( var gameObject:FlxSprite in objectMap)
			{
				gameObject.update();
			}
			
			//TODO game logic (enemy spawning, etcetera) goes here, instead of this random ass random
			
			if (FlxG.random() < 0.01)
			{
				var f:ManagedFlxSprite = new ManagedFlxSprite(mapSize.x * FlxG.random(), mapSize.y * FlxG.random(), this, idCounter, 10);
				this.objectMap[f.managedID] = f;
				reportEvent( new Array(event_spawn, idCounter, f.x, f.y, f.type) );// spawn new game object of ID 0 at random coordinates within map;
				idCounter++;
			}
		}
		
		override public function reportEvent( event:Array ):void
		{
			trace(event);
			this.gameEvents.push(event);
		}
		
		override public function getGameEvent():Array {
			//returns first element in gameEvents
			if (parsedEvents.length > 0) {
				return parsedEvents.splice(0,1)[0];//remove and return first element
			}
			return null;
		}
		
		override public function getPlayer():FlxSprite
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
		
		protected function makeGameSprite(id:int, x:int, y:int, MSID:int ):FlxSprite {
			var f:ManagedFlxSprite = MSLib.getMFlxSprite(MSID, x, y, this, id)
			trace(f);
			return f
		}
		
	}
}