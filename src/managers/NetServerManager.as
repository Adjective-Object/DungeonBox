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
		protected var clients:Array = new Array();
		
		protected var pushMessages:Array = new Array();//messages to push to clients
		
		public function NetServerManager() 
		{
			this.hostSocket = new ServerSocket();
			trace("Serversocket.isSupported "+ServerSocket.isSupported);
            this.hostSocket.addEventListener( ServerSocketConnectEvent.CONNECT, onConnect );
			this.hostSocket.bind( 13756 );
			this.hostSocket.listen();
			trace("Serversocket bound "+this.hostSocket.bound);
			trace("Serversocket listening "+this.hostSocket.listening);
			super();
		}
		
		private function onConnect( event:ServerSocketConnectEvent ):void
        {
			if(clients.length<2){
				var clientSocket = event.socket;
				this.pushMessages.push( new Array() );
				clients.push(clientSocket);
				trace( "Connection from " + clientSocket.remoteAddress + ":" + clientSocket.remotePort );
				if (clients.length == 1) {
					clientSocket.addEventListener( ProgressEvent.SOCKET_DATA, onClientData0 );
				}
				if (clients.length == 2) {
					clientSocket.addEventListener( ProgressEvent.SOCKET_DATA, onClientData1 );
				}
			}
        }
		
		public override function update():void{
			super.update();
			var msg = getGameEvent();
			while (msg!=null){
				for (var x:int = 0; x<this.clients.length; x++){
					sendEventMessage(this.clients[x],msg);
				}
				msg = getGameEvent();
			}

		}
		
		public function onClientData0( event:ProgressEvent) {
			var msg = handleMessage(this,clients[0]);
			this.pushMessages[0].push(msg);
			this.parseEvent(msg);
		}
		
		public function onClientData1( event:ProgressEvent) {
			var msg = handleMessage(this,clients[0]);
			this.pushMessages[1].push(msg);
			this.parseEvent(msg);
		}
		public static function sendEventMessage( client:Socket, message:Array ):void {
			var msgTyping:String = Manager.msgConfigs[message[0]];
			for(var i:int = 0; i<message.length; i++){
				if(msgTyping.charAt(i)=='i'){
					client.writeInt(message[i]);
				} else if(msgTyping.charAt(i)=='s'){
					client.writeUTF(message[i]);
				}
			}
		}
			
		public static function handleMessage( m:Manager, client:Socket):Array {
			var evtType:int = client.readInt();
			var argsConfig:String = Manager.msgConfigs[evtType];
			
			var args:Array = new Array();
			
			trace(Manager.msgConfigs, evtType);
			trace(argsConfig);
			
			for (var i:int = 0; i < argsConfig.length; i++ ) {
				if (argsConfig.charAt(i) == 'i') {
					args.push(client.readInt());
				} else if (argsConfig.charAt(i) == 's'){
					args.push(client.readUTFBytes(4));
				}
			}
			
			trace(m+" got Message " + evtType + " " + argsConfig + " " + args);
			
			m.reportEvent(args);
			return args;
		}
	}

}
