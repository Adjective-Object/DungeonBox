package  
{
	
	import org.flixel.*;
	
	/**
	 * Simulates Client-server connection
	 * @author Maxwell Huang-Hobbs
	 */
	public class DummyManager extends Manager
	{
		
		private var pipedManager:LocalManager;
		
		public function DummyManager(manager:LocalManager) 
		{	
			super();
			this.pipedManager = manager;
			this.clientSide = true;
		}
		
		override public function update():void
		{
			this.pipedManager.update();
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