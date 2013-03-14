package managers 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
	/**
	 * ...
	 * @author Maxwell Huang-Hobbs
	 */
	public class NetClientManager extends ClientManager
	{
		
		protected var server:Socket;
		
		public function NetClientManager(child:PlayState) 
		{
			this.server = new Socket();
			configureListeners(this.server);
			this.server.connect( "127.0.0.1", 13756 );
			super(child);
		}
		
		private function configureListeners( s:Socket ):void {
			s.addEventListener(Event.CLOSE, closeHandler);
			s.addEventListener(Event.CONNECT, connectHandler);
			s.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			s.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			s.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		/**
		 * tells the manager of stuff happening in the PlayState.
		 */
		override public function reportEvent( event:Array ):void
		{
			//trace("client reporting event "+event);
			NetServerManager.sendEventMessage( this.server, event );
			trace(this,"sends Message",event);
		}
		
		private function socketDataHandler(event:ProgressEvent):void {
			while (this.server.bytesAvailable>0){
				trace(this.server.bytesAvailable);
				this.gameEvents.push( NetServerManager.handleMessage(this,this.server) );
			}
			trace(this+" done Handling Messages");
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