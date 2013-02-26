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
		protected var gameObjects:Dictionary = new Dictionary();//dictionary of manager-handled object
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
					this.gameObjects[args[0]] = makeGameSprite(args[0], args[1], args[2], args[3])
					if (this.gameObjects[args[0]].type == Player.MSType) {
						this.child.setPlayer(this.gameObjects[args[0]]);
					}
					this.child.managedSprites.add(this.gameObjects[args[0]]);
					break;
				case Manager.event_update_position:
					this.gameObjects[args[0]].x = args[1];
					this.gameObjects[args[0]].y = args[2];
					break;
				case Manager.event_update_health:
					this.gameObjects[args[0]].hp = args[1];
					break;
				
				default:
					break;
			}
		}	
		
		protected function makeGameSprite(id:int, x:int, y:int, MSID:int ):FlxSprite {
			var f:ManagedFlxSprite = MSLib.getMFlxSprite(MSID,x,y,this,id);
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
		
		public override function spawn( e:ManagedFlxSprite):void
		{
			pipedManager.reportEvent( Manager.getSpawnEvent(e) );
		}
		public override function updatePosition( e:ManagedFlxSprite):void
		{
			pipedManager.reportEvent( Manager.getUpdatePosEvent(e));
		}
		public override function updateHealth( e:ManagedFlxSprite):void 
		{
			pipedManager.reportEvent( Manager.getUpdateHPEvent(e));
		}
		public override function kill(e:ManagedFlxSprite):void
		{
			pipedManager.reportEvent( Manager.getKillEvent(e));
		}
	}

}