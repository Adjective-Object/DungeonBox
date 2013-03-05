package managers 
{
	import flash.net.Socket;
	/**
	 * ...
	 * @author Maxwell Huang-Hobbs
	 */
	public class NetClientManager extends Manager
	{
		
		protected var server:Socket;
		
		public function NetClientManager() 
		{
			this.server = new Socket();
			configureListeners();
			this.server.connect( "localhost", 13756 );
		}
		
		private function configureListeners():void {
			addEventListener(Event.CLOSE, closeHandler);
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		private function socketDataHandler(event:ProgressEvent):void {
			NetServerManager.handleMessage(this.server);
		}
		
		//unexpected things happen:
		private function closeHandler(event:Event):void {
			trace("closeHandler: " + event);
			trace(response.toString());
		}

		private function connectHandler(event:Event):void {
			trace("connectHandler: " + event);
			sendRequest();
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}		
	}

}