package managers 
{
	import flash.net.Socket;
	import flash.events.ServerSocketConnectEvent;
	import flash.events.ProgressEvent;
	import flash.net.ServerSocket;

	/**
	 * ...
	 * @author Maxwell Huang-Hobbs
	 */
	public class NetServerManager extends LocalManager
	{
		protected var hostSocket:ServerSocket;
		protected var client1:Socket;
		protected var client2:Socket;
		
		protected var pushMessages1:Array = new Array();//messages to push to client 1
		protected var pushMessages2:Array = new Array();//messages to push to client 2
		
		public function NetServerManager() 
		{
			this.hostSocket = new ServerSocket();
            this.hostSocket.addEventListener( ServerSocketConnectEvent.CONNECT, onConnect );
			this.hostSocket.bind(13756, "localhost");
			this.hostSocket.listen();
		}
		
		private function onConnect( event:ServerSocketConnectEvent ):void
        {
			if(clients.length<2){
				clientSocket = event.socket;
				log( "Connection from " + clientSocket.remoteAddress + ":" + clientSocket.remotePort );
				if (clients.length == 1) {
					this.pushMessages1.clear();
					clientSocket.addEventListener( ProgressEvent.SOCKET_DATA, onClientData1 );
					client1 = clientSocket;
				}
				if (clients.length == 2) {
					this.pushMessages2.clear();
					clientSocket.addEventListener( ProgressEvent.SOCKET_DATA, onClientData2 );
					client2 = clientSocket;
				}
			}
        }
		
		public function onClientData1( event:ProgressEvent) {
			this.pushMessages2.push(getClientMessage(client1));
		}
		
		public function onClientData2( event:ProgressEvent) {
			this.pushMessages2.push(getClientMessage(client2));
		}
		
		public function handleMessage( client:Socket):Array {
			var evtType:int = client.readInt;
			var argsConfig:String = Manager.msgConfigs[evtType];
			
			var args:Array = new Array();
			
			for (var i:int = 0; i < argsConfig.length; i++ ) {
				if (argsConfig.charAt(i) == 'i') {
					args.push(client.readInt());
				} else if (argsConfig.charAt(i) == 's'){
					args.push(client.readUTFBytes(4);
				}
			}
			
			trace("Server got Message " + evtType + " "argsConfig + " " + args);
			
			this.reportEvent(args);
			return args;
		}
	}

}
