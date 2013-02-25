package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	import managedobjs.Player;
	
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Maxwell Huang-Hobbs
	 */
	public class LocalManager extends Manager
	{	
		protected var objectMap:Dictionary = new Dictionary();//dictionary of server-handled object
		protected var playerOne:FlxSprite;
		protected var playerTwo:FlxSprite;
		
		protected static var numPlayers:int = 2;
		
		protected var gameEvents:Array = new Array();
		protected var idCounter:int;

		public function LocalManager( clientSide:Boolean = false) 
		{
			this.clientSide = clientSide;
			
			this.idCounter = 0;
			
			this.playerOne = new Player(mapSize.x / 2 - 50, mapSize.y / 2, this, idCounter);
			idCounter++;
			this.playerTwo =  new Player(mapSize.x / 2 - 50, mapSize.y / 2, this, idCounter);
			idCounter++;
			
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
			
			for each( var gameObject:FlxSprite in objectMap)
			{
				gameObject.update();
			}
			
			//TODO game logic (enemy spawning, etcetera) goes here, instead of this random ass random
			
			if (FlxG.random() < 0.01)
			{
				var f:ManagedFlxSprite = new ManagedFlxSprite(mapSize.x * FlxG.random(), mapSize.y * FlxG.random(), this, idCounter, 10);
				this.objectMap[f.managedID] = f;
				gameEvents.push( new Array(event_spawn, idCounter, f.x, f.y, f.type) );// spawn new game object of ID 0 at random coordinates within map;
				idCounter++;
			}
		}
		
		override public function reportEvent( event:Array ):void
		{
			this.gameEvents.add(event)
		}
		
		override public function getGameEvent():Array {
			//returns first element in gameEvents
			if (gameEvents.length > 0) {
				var p:Array = gameEvents[0];
				gameEvents.splice(0,1);//remove first element
				return p;
			}
			return null;
		}
		
		override public function getPlayer():FlxSprite
		{
			return this.playerOne;
		}
		
	}
}