package
{
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	
	import managers.NetClientManager;
	import managers.NetServerManager;
	
	import org.flixel.*;
	
	public class HostLobby extends FlxState
	{
		protected var hostSocket:ServerSocket;
		protected var clients:Array = new Array();
		public var listenPort:uint;
		protected var mastraubatorySocket:Socket;
		
		protected var clientTexts:Array;
		protected var focus:uint=0;
		
		protected static var textSpacing:uint = 40;
		protected static var textOrigin:uint = 200;
		
		public function HostLobby(port:uint=1337)
		{
			this.listenPort = port;
		}
		
		public override function create():void{
			//create listening server
			this.hostSocket = new ServerSocket();
			this.hostSocket.addEventListener( ServerSocketConnectEvent.CONNECT, onConnect );
			this.hostSocket.bind( listenPort );
			this.hostSocket.listen();
			
			trace("Serversocket bound "+this.hostSocket.bound);
			trace("Serversocket listening "+this.hostSocket.listening);
			
			//visual things
			createBonesGUI();
			this.clientTexts = new Array();
			
			//connect to self
			this.mastraubatorySocket = new Socket();
			this.mastraubatorySocket.connect( "127.0.0.1", listenPort );
			this.mastraubatorySocket.writeUTF("HOST");
			this.mastraubatorySocket.flush();
		}
		
		public function createBonesGUI():void{
			var title:FlxText;
			title = new FlxText(0, 16, FlxG.width, "Hosting Lobby");
			title.setFormat (null, 20, 0xFFFFFFFF, "center");
			this.add(title);
			
			var instructions:FlxText;
			instructions = new FlxText(0, FlxG.height - 56, FlxG.width, "k to kick selected (blue) person from lobby");
			instructions.setFormat (null, 8, 0xFFFFFFFF, "center");
			add(instructions);
			
			instructions = new FlxText(0, FlxG.height - 44, FlxG.width, "space / enter to start");
			instructions.setFormat (null, 8, 0xFFFFFFFF, "center");
			add(instructions);
			
			instructions = new FlxText(0, FlxG.height - 32, FlxG.width, "esc to abort lobby and return to main screen");
			instructions.setFormat (null, 8, 0xFFFFFFFF, "center");
			add(instructions);
		}
		
		function doColors(){
			for(var i:int = 0; i<clientTexts.length; i++){
				if(focus==i){
					clientTexts[i].color = 0x00ffff;
				} else{
					clientTexts[i].color = 0xffffff;
				}
			}
		}
		
		
		public override function update():void{
			//moving selector
			var up:Boolean = FlxG.keys.justPressed("UP");
			var down:Boolean = FlxG.keys.justPressed("DOWN");
			if ( up || down ){
				if(up)	{ focus = (focus-1)%clientTexts.length;}
				if(down){ focus = (focus+1)%clientTexts.length;}
				doColors();
			}
			
			if( FlxG.keys.justPressed("K") ){//kicking selected player
				removePlayer(focus);
				focus=focus%clientTexts.length;
			}
			
			if( FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("SPACE") ){//kicking selected player
				FlxG.switchState ( new PlayState(new NetClientManager( this.mastraubatorySocket ) , new NetServerManager(clients) ) );
			}
			
			if( FlxG.keys.justPressed("ESCAPE")){//kicking selected player
				this.abortLobby()
				FlxG.switchState ( new MenuState() );
			}
			
		}
		
		
		public function addNewPlayer(s:Socket):void{
			this.clients.push(s);
			var text:FlxText = new FlxText(0, FlxG.height - 56, FlxG.width, s.readUTF());//reads UTF string from socket and assigns that as the name of the user
			text.setFormat (null, 8, 0xFFFFFFFF, "center");
			add(text);
			this.clientTexts.add(text);
		}
		
		public function removePlayer(playerNumber:uint):void{
			this.clients[playerNumber].close();
			this.remove( this.clientTexts[playerNumber] );
			delete this.clientTexts[playerNumber];
			for(var i:uint=playerNumber+1; i<clientTexts.length; i++){
				clientTexts[i].y-=HostLobby.textSpacing;
			}
		}
		
		public function abortLobby(){
			this.hostSocket.close();
			for(var i:int=0; i<this.clients.length; i++){
				clients[i].close();
			}
		}
		
		
		
		
		
		private function onConnect( event:flash.events.ServerSocketConnectEvent ):void
		{
			var clientSocket:flash.net.Socket = event.socket;
			
			trace( "Connection from " + clientSocket.remoteAddress + ":" + clientSocket.remotePort );
			clients.push(clientSocket);
		}
		
	}
	
}