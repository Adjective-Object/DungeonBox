package managers 
{
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;

	/**
	 * ...
	 * @author Maxwell Huang-Hobbs
	 */
	public class NetServerManager extends LocalManager
	{
		protected var hostSocket:ServerSocket;
		protected var clients:Array;
		
		protected var pushMessages:Array = new Array();//messages to push to clients
		
		public function NetServerManager() 
		{
			this.hostSocket = new ServerSocket();
			trace(ServerSocket.isSupported);
            this.hostSocket.addEventListener( ServerSocketConnectEvent.CONNECT, onConnect );
			this.hostSocket.bind( 13756, "128.0.0.1" );
			this.hostSocket.listen();
		}
		
		private function onConnect( event:ServerSocketConnectEvent ):void
        {
			if(clients.length<2){
				var clientSocket = event.socket;
				clients.push(clientSocket);
				this.pushMessages[clients.length]= new Array();
				trace( "Connection from " + clientSocket.remoteAddress + ":" + clientSocket.remotePort );
				if (clients.length == 1) {
					clientSocket.addEventListener( ProgressEvent.SOCKET_DATA, onClientData0 );
				}
				if (clients.length == 2) {
					clientSocket.addEventListener( ProgressEvent.SOCKET_DATA, onClientData1 );
				}
			}
        }
		
		public function onClientData0( event:ProgressEvent) {
			this.pushMessages[1].push(handleMessage(this,clients[0]));
		}
		
		public function onClientData1( event:ProgressEvent) {
			this.pushMessages[0].push(handleMessage(this,clients[1]));
		}
		
		public static function handleMessage( m:Manager, client:Socket):Array {
			var evtType:int = client.readInt();
			var argsConfig:String = Manager.msgConfigs[evtType];
			
			var args:Array = new Array();
			
			for (var i:int = 0; i < argsConfig.length; i++ ) {
				if (argsConfig.charAt(i) == 'i') {
					args.push(client.readInt());
				} else if (argsConfig.charAt(i) == 's'){
					args.push(client.readUTFBytes(4));
				}
			}
			
			trace("Server got Message " + evtType + " " + argsConfig + " " + args);
			
			m.reportEvent(args);
			return args;
		}
	}

}
