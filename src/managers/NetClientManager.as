package managers 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
	import managedobjs.PlayerControlled;
	
	/**
	 * ...
	 * @author Maxwell Huang-Hobbs
	 */
	public class NetClientManager extends ClientManager
	{
		
		protected var server:Socket;
		
		public function NetClientManager(toServer:Socket) 
		{
			this.server = toServer;
			while(this.server.bytesAvailable>0){
				trace("client has leftover bytes",this.server.bytesAvailable);
				this.server.readByte();
			}
			configureListeners(this.server);
			super();
		}
		
		private function configureListeners( s:Socket ):void {
			s.addEventListener(Event.CLOSE, closeHandler);
			s.addEventListener(Event.CONNECT, connectHandler);
			s.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			s.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			s.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		override public function update():void
		{	
			//PARSE EVENTS
			
			var event:Array = this.getGameEvent();
			while (event != null){
				parseEvent(event);
				event = this.getGameEvent();
			}
		}
		
		override public function getGameEvent():Array
		{
			var p:Array =  super.getGameEvent();
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
			NetServerManager.sendEventMessage( this.server, event);
		}
		
		private function socketDataHandler(event:ProgressEvent):void {
			while (this.server.bytesAvailable>0){
				var p =NetServerManager.handleMessage(this,this.server, false);
				if(p!=null){
					this.gameEvents.push( p );
				}
			}
			//for(var i:int=0; i<gameEvents.length; i++){
			//	trace(i, ":", this.gameEvents[i]);
			//}
		}
		
		//unexpected things happen:
		private function closeHandler(event:Event):void {
			trace("client close event: " + event);
		}

		private function connectHandler(event:Event):void {
			trace("client connect event: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("client ioerror: " + event);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("client security error: " + event);
		}		
	}

}