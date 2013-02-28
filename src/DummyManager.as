package  
{
	
	import flash.utils.Dictionary;
	
	import managedobjs.MSLib;
	import managedobjs.Player;
	
	import org.flixel.*;
	
	/**
	 * Simulates Client-server connection
	 * @author Maxwell Huang-Hobbs
	 */
	public class DummyManager extends Manager
	{
		
		private var pipedManager:LocalManager;
		protected var gameObjects:FlxGroup = new FlxGroup();//dictionary of manager-handled object
		private var child:PlayState;
		
		public function DummyManager(manager:LocalManager, child:PlayState) 
		{	
			super();
			this.pipedManager = manager;
			this.clientSide = true;
			this.child = child;
		}
		
		override public function update():void
		{
			this.pipedManager.update();
			
			//PARSE EVENTS FROM MANAGER
			
			var event:Array = this.pipedManager.getGameEvent();
			while (event != null){
				parseEvent(event.splice(0,1)[0],event);
				event = this.pipedManager.getGameEvent();
			}
		}

		//TODO can you spell duplicate code?
		protected function parseEvent(type:int, args:Array):void
		{
			switch(type) 
			{
				case Manager.event_spawn:
					this.gameObjects.members[args[0]] = makeGameSprite(args[0], args[1], args[2], args[3], args[4])
					if (this.gameObjects.members[args[0]].type == Player.MSType) {
						this.child.setPlayer(this.gameObjects.members[args[0]]);
					}
					this.child.managedSprites.add(this.gameObjects.members[args[0]]);
					break;
				case Manager.event_update_position:
					this.gameObjects.members[args[0]].x = args[1];
					this.gameObjects.members[args[0]].y = args[2];
					break;
				case Manager.event_update_animation:
					this.gameObjects.members[args[0]].play(args[1]);
					this.gameObjects.members[args[0]].facing = args[2];
					break;
				case Manager.event_update_health:
					this.gameObjects.members[args[0]].hp = args[1];
					break;
				case Manager.event_damage:
					this.child.add(new DamageText(gameObjects.members[args[0]].x, gameObjects.members[args[0]].y, args[1] ))
					break;
				default:
					break;
			}
		}	
		
		protected function makeGameSprite(id:int, x:int, y:int, MSID:int, facing:int ):FlxSprite {
			var f:ManagedFlxSprite = MSLib.getMFlxSprite(MSID,x,y,this,id,facing);
			return f
		}
		/**
		 * returns game event
		 * if there is a game event to report, returns Array( type,  args )
		 * 
		 * if there is not a game event to report, returns null
		 */
		override public function getGameEvent():Array
		{
			return this.pipedManager.getGameEvent();
		}
		
		/**
		 * tells the manager of stuff happening in the PlayState.
		 */
		override public function reportEvent( event:Array ):void
		{
			this.pipedManager.reportEvent(event);
		}
		
		/**
		 * tells the PlayState the sprite it is in control of.
		 * 
		 * @return the player FlxSprite
		 */
		override public function getPlayer():ManagedFlxSprite
		{
			return this.pipedManager.getPlayer();
		}
		public override function getEntity( id:uint):ManagedFlxSprite
		{
			return this.pipedManager.getEntity(id);
		}
		public override function getAllSprites():FlxGroup {
			return this.gameObjects;
		}
		
		public override function spawn( e:ManagedFlxSprite):void
		{
			reportEvent(Manager.getSpawnEvent(e));
		}
		public override function updatePosition( e:ManagedFlxSprite):void
		{
			this.reportEvent(Manager.getUpdatePosEvent(e));
		}
		public override function updateHealth( e:ManagedFlxSprite):void
		{
			this.reportEvent(Manager.getUpdateHPEvent(e));
		}
		public override function updateAnimation( e:ManagedFlxSprite):void
		{
			this.reportEvent(Manager.getUpdateAnimEvent(e));
		}
		public override function kill( e:ManagedFlxSprite):void
		{
			this.reportEvent(Manager.getKillEvent(e));
		}
		public override function damage( e:ManagedFlxSprite, damage:int ):void
		{
			this.reportEvent(Manager.getDamageEvent(e,damage));
		}
	}

}