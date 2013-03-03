package  
{
	import flash.utils.Dictionary;
	
	import managedobjs.*;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Maxwell Huang-Hobbs
	 */
	public class LocalManager extends Manager
	{	
		protected var objectMap:FlxGroup = new FlxGroup();//dictionary of server-handled object
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
			
			var f:ExampleEnemy = new ExampleEnemy((mapSize.x-11) * FlxG.random(), (mapSize.y-15) * FlxG.random(), this, idCounter);
			f.spawn();
			
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
			for each( var gameObject:ManagedFlxSprite in objectMap.members)
			{
				gameObject.update();
				gameObject.postUpdate();
				if (!gameObject.alive) {
					trace(gameObject+" "+ gameObject.managedID + " has died");
					this.pushEvent(Manager.getKillEvent(gameObject));
					delete objectMap.members[gameObject.managedID];
				}
			}
			
			//TODO game logic (enemy spawning, etcetera) goes here, instead of this random ass random
			if (FlxG.random() < 0.001 || FlxG.keys.pressed("SPACE") ) {
				var m:ManagedFlxSprite = MSLib.getMFlxSprite(
					ExampleEnemy.MSType,
					FlxG.random() * this.mapSize.x,
					FlxG.random() * this.mapSize.y,
					this,
					this.idCounter);
				m.facing = (int)(Math.round(FlxG.random()));//cosmetic
				m.align = Manager.align_enemy;	
				this.spawn(m);
			}
		}
		
		override public function reportEvent( event:Array ):void
		{
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
		
		override public function getAllSprites():FlxGroup
		{
			return this.objectMap;
		}
		
		protected function parseEvent(args:Array):void
		{
			var type = args[0]
			switch(type) 
			{
				case Manager.event_spawn:
					trace("spawn_via_event "+args);
					spawn(makeGameSprite(args[1], args[2], args[3], args[4], args[5], args[6]));
				break;
				case Manager.event_update_position:
					this.objectMap.members[args[1]].x = args[2];
					this.objectMap.members[args[1]].y = args[3];
				break;
				case Manager.event_update_health:
					this.objectMap.members[args[1]].hp = args[2];
				break;
				case Manager.event_kill:
					trace("kill_via_event "+this.objectMap.members[args[1]]);
					delete this.objectMap.members[args[1]];
				break;
				case Manager.event_knockback:
					this.objectMap.members[args[1]].knockBack(args[2], args[3]);
					break;
				case Manager.event_debuff:
					if (args[3] == 0) {
						DebuffHandler.removeDebuff(this.objectMap.members[args[1]], args[2]);
					}else {
						DebuffHandler.applyDebuff(this.objectMap.members[args[1]], args[2]);
					}
				break;
				
				default:
				break;
			}
		}	
		
		protected function makeGameSprite(id:int, x:int, y:int, MSID:int, align:int, facing:int):ManagedFlxSprite {
			var f:ManagedFlxSprite = MSLib.getMFlxSprite(MSID, x, y, this, id);
			f.facing = facing;
			f.align = align;
			return f
		}
		
		public override function getEntity( id:uint):ManagedFlxSprite
		{
			return this.objectMap.members[id];
		}
		
		public override function spawn( e:ManagedFlxSprite ):void
		{
			e.managedID=idCounter;
			this.objectMap.members[idCounter] = e;
			idCounter++;
			this.pushEvent(  Manager.getSpawnEvent(e) );
		}
		
		public override function updatePosition( e:ManagedFlxSprite):void
		{
			this.pushEvent( Manager.getUpdatePosEvent(e) );
		}
		public override function updateHealth( e:ManagedFlxSprite):void
		{
			this.pushEvent( Manager.getUpdateAnimEvent(e) );
		}
		public override function updateAnimation( e:ManagedFlxSprite):void
		{
			this.pushEvent(Manager.getUpdateAnimEvent(e));
		}
		public override function damage( e:ManagedFlxSprite, damage:int ):void
		{
			this.pushEvent( Manager.getDamageEvent(e,damage) );
		}
		public override function kill( e:ManagedFlxSprite):void
		{
			this.pushEvent( Manager.getKillEvent(e) );
			delete this.objectMap.members[e.managedID];
		}
		public override function knockBack(e:ManagedFlxSprite, x:int, y:int):void{
			this.reportEvent( Manager.getKnockbackEvent(e,x,y) );
		}
		public override function applyDebuff( e:ManagedFlxSprite, debuffID:int ):void {
			this.reportEvent( Manager.getDebuffEvent(e,debuffID) );
			this.pushEvent(  Manager.getDebuffEvent(e,debuffID) );
		}
		public override function removeDebuff( e:ManagedFlxSprite, debuffID:int ):void {
			this.reportEvent( Manager.getDebuffClearEvent(e,debuffID) );
			this.pushEvent(  Manager.getDebuffClearEvent(e,debuffID) );
		}

		
		
		public static function countKeys(myDictionary:FlxGroup):int 
		{		
			var n:int = 0;
			for (var key:* in myDictionary) {
				n++;
			}
			return n;
		}
		
	}
}