package managers 
{
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author Maxwell Huang-Hobbs
	 */
	public class NetServerManager extends HostManager
	{
		protected var hostSocket:ServerSocket;
		protected var clients:Array = new Array();
		protected var referenceNumbers:Dictionary = new Dictionary();
		
		protected var pushMessages:Array = new Array();//messages to push to clients
		
		public function NetServerManager() 
		{
			super();
			this.parsedEvents = new Array();
			this.hostSocket = new ServerSocket();
			trace("Serversocket.isSupported "+ServerSocket.isSupported);
            this.hostSocket.addEventListener( ServerSocketConnectEvent.CONNECT, onConnect );
			this.hostSocket.bind( 13756 );
			this.hostSocket.listen();
			trace("Serversocket bound "+this.hostSocket.bound);
			trace("Serversocket listening "+this.hostSocket.listening);
		}
		
		public override function update():void{
			super.update();
			var msg = getGameEvent();
			while (msg!=null){
				for (var x:int = 0; x<this.clients.length; x++){
					sendEventMessage(this.clients[x],msg);
					
					trace(this, "sends Message", msg);
				}
				msg = getGameEvent();
			}
		}
		
		private function onConnect( event:ServerSocketConnectEvent ):void
		{
			var clientSocket:Socket = event.socket;
			this.pushMessages.push( new Array() );
			referenceNumbers[clientSocket] = clients.length;
			clientSocket.addEventListener( ProgressEvent.SOCKET_DATA, onClientData );
			clients.push(clientSocket);
			trace( "Connection from " + clientSocket.remoteAddress + ":" + clientSocket.remotePort );
			
			for each( var gameObject:ManagedFlxSprite in objectMap.members){
				var p = Manager.getSpawnEvent(gameObject);
				trace(this, "sends Message",p);
				sendEventMessage( clientSocket,  p);
			}
		}
		
		public function onClientData( event:ProgressEvent ):void {
			var clientNumber = referenceNumbers[event.target];
			while(clients[clientNumber].bytesAvailable>0){
				var msg = handleMessage(this,clients[clientNumber],true);
				this.pushMessages[clientNumber].push(msg);
				this.parseEvent(msg);
			}
		}
		
		public static function sendEventMessage( client:Socket, message:Array ):void {
			var msgTyping:String = Manager.msgConfigs[message[0]];
			//trace(message);
			client.writeInt(message[0]);
			for(var i:int = 1; i<message.length; i++){
				if(msgTyping.charAt(i-1)=='i'){
					client.writeInt(message[i]);
				} else if(msgTyping.charAt(i-1)=='s'){
					client.writeUTF(message[i]);
				} else{
					trace(message[0],msgTyping,"i dunno how to '",msgTyping.charAt(i),"'");
				}
			}
		}
			
		public static function handleMessage( m:Manager, client:Socket, verbose:Boolean=false):Array {
			var evtType:int = client.readInt();
			var argsConfig:String = Manager.msgConfigs[evtType];
			
			
			var args:Array = new Array();
			args.push(evtType);
			
			//trace(Manager.msgConfigs, evtType);
			//trace(argsConfig);
			
			for (var i:int = 0; i < argsConfig.length; i++ ) {
				if (argsConfig.charAt(i) == 'i') {
					args.push(client.readInt());
				} else if (argsConfig.charAt(i) == 's'){
					args.push(client.readUTF());
				} else if (verbose){
					trace("Server doesn't know how to handle",argsConfig.charAt(i));
				}
			}
			if(verbose){
				trace(m, "got Message", argsConfig, args);
			}
			
			return args;
		}
	}

}
