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
			this.server.connect( "128.0.0.1", 13756 );
			super(child);
		}
		
		private function configureListeners( s:Socket ):void {
			s.addEventListener(Event.CLOSE, closeHandler);
			s.addEventListener(Event.CONNECT, connectHandler);
			s.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			s.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			s.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		private function socketDataHandler(event:ProgressEvent):void {
			NetServerManager.handleMessage(this,this.server);
		}
		
		//unexpected things happen:
		private function closeHandler(event:Event):void {
			trace("closeHandler: " + event);
		}

		private function connectHandler(event:Event):void {
			trace("connectHandler: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}		
	}

}