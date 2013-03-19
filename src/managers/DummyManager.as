package managers  
{
	
	import flash.utils.Dictionary;
	
	import managedobjs.*;
	
	import org.flixel.*;
	
	/**
	 * Simulates Client-server connection
	 * @author Maxwell Huang-Hobbs
	 */
	public class DummyManager extends ClientManager
	{
		
		private var pipedManager:HostManager;
		
		public function DummyManager( child:PlayState, manager:HostManager ) 
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
			var p:Array =  this.pipedManager.getGameEvent();
			if ( p!=null && p[0]==Manager.event_spawn && p[1] == 0){
				p[4]=PlayerControlled.MSType;
			}
			return p
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