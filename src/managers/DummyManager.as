package managers  
{
	
	import flash.utils.Dictionary;
	
	import managedobjs.MSLib;
	import managedobjs.Player;
	import managedobjs.DebuffHandler;
	
	
	import org.flixel.*;
	
	/**
	 * Simulates Client-server connection
	 * @author Maxwell Huang-Hobbs
	 */
	public class DummyManager extends ClientManager
	{
		
		private var pipedManager:HostManager;
		
		public function DummyManager( child:PlayStateNetworked, manager:HostManager ) 
		{	
			super(child);
			this.pipedManager = manager;
		}
		
		override public function update():void
		{
			this.pipedManager.update();
			super.update();
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
		
	}

}