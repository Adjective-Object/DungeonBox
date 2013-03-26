package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
	import managers.NetClientManager;
	
	import org.flixel.*;
	

	public class ClientLobby extends FlxState
	{
		
		protected var socket:Socket;
		
		protected var inputText:InputText;
		protected var errorText:FlxText;
		protected var promptText:FlxText;
		
		protected var  gettingName:Boolean = true;
		protected var  name:String = "nameless";
		
		public function ClientLobby(){}
		
		
		public override function create():void{
			//create listening server
			this.socket = new Socket();
			establishListeners();
			
			this.inputText = new InputText(0, 200, FlxG.width);
			this.inputText.setFormat (null, 20, 0xFFFFFFFF, "center");
			this.add(this.inputText);
			
			
			this.errorText = new FlxText(0, 224, FlxG.width, "");
			this.errorText.setFormat (null, 8, 0xFFFFFFFF, "center");
			add(this.errorText);
			
			this.promptText = new FlxText(0, 188, FlxG.width, "name?");
			this.promptText.setFormat (null, 8, 0xFFFFFFFF, "center");
			add(this.promptText);
			
			//visual things
			createBonesGUI();
		}
		
		public override function update():void{
			super.update();
			
			if(gettingName)
			{
				if(FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("SPACE")){
					this.name=this.inputText.text;
					this.inputText.text = "";
					this.promptText.text = "server address?"
					this.gettingName=false;
				}
			}
			else
			{	
				if(FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("SPACE")){
					this.errorText.text = this.attemptConnect(this.inputText.text);
				}
			}
			
			if( FlxG.keys.justPressed("ESCAPE")){//leaving lobby
				this.abortLobby();
				FlxG.switchState ( new MenuState() );
			}
		}
		
		
		
		
		
		
		public function attemptConnect(addressString:String):String{
			var temp:Array = addressString.split(":");
			var ip:String = temp[0];
			var port:int;

			if(temp.length>1){
				port = int(temp[1]);
			} else{
				port = 1337;
			}
			trace (ip, port);
			socket.connect(ip,port);
			
			return "attempting to connect to "+ip+":"+port+"..."
		}
		
		public function createBonesGUI():void{
			var title:FlxText;
			title = new FlxText(0, 16, FlxG.width, "Client Lobby");
			title.setFormat (null, 20, 0xFFFFFFFF, "center");
			this.add(title);
			
			var instructions:FlxText;
			instructions = new FlxText(0, FlxG.height - 56, FlxG.width, "type out address, format ip:port. default port is 1337 ");
			instructions.setFormat (null, 8, 0xFFFFFFFF, "center");
			add(instructions);
			
			instructions = new FlxText(0, FlxG.height - 44, FlxG.width, "space / enter to attempt connection");
			instructions.setFormat (null, 8, 0xFFFFFFFF, "center");
			add(instructions);
			
			instructions = new FlxText(0, FlxG.height - 32, FlxG.width, "esc to abort lobby and return to main screen");
			instructions.setFormat (null, 8, 0xFFFFFFFF, "center");
			add(instructions);
		}
		
		public function abortLobby(){
			if(this.socket.connected){
				this.socket.close();
			}
		}
		
		
		public function closeHandler(event:Event){
			trace(event);
		}
		
		public function connectHandler(event:Event){
			trace(event);
			this.errorText.text = "connected to server at " + this.socket.remoteAddress+":"+this.socket.remotePort;
			socket.writeShort(this.name.length);//because writeUTF donot work
			socket.writeUTF(this.name);
		}
		
		public function ioErrorHandler(event:IOErrorEvent){
			trace("IOERROR",event);
			this.errorText.text = "cannot connect to server\n"+event.text;

		}
		
		public function securityErrorHandler(event:SecurityErrorEvent){
			trace("socket security error",event);
		}
		
		public function socketDataHandler(event:ProgressEvent){
			var msg = this.socket.readUTF();
			trace(msg);
			if(msg=="StartGame"){
				this.removeListeners();
				FlxG.switchState(new PlayState( new NetClientManager(this.socket) ));
			}
		}
		
		public function establishListeners(){
			this.socket.addEventListener(Event.CLOSE, closeHandler);
			this.socket.addEventListener(Event.CONNECT, connectHandler);
			this.socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			this.socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		public function removeListeners(){
			this.socket.removeEventListener(Event.CLOSE, closeHandler);
			this.socket.removeEventListener(Event.CONNECT, connectHandler);
			this.socket.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			this.socket.removeEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
	}
}