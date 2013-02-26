package  
{
	import flash.net.GroupSpecifier;
	import org.flixel.*;
	import managedobjs.*;
	
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Maxwell Huang-Hobbs
	 */
	
	public class PlayState extends FlxState
	{
		[Embed(source = "/../res/cursor.png")] private var cursor:Class;
		
		
		
		[Embed(source = "/../res/T_0.png")] private var T0:Class;
		[Embed(source = "/../res/T_1.png")] private var T1:Class;
		[Embed(source = "/../res/T_2.png")] private var T2:Class;
		[Embed(source = "/../res/T_3.png")] private var T3:Class;
		[Embed(source = "/../res/T_4.png")] private var T4:Class;
		[Embed(source = "/../res/T_5.png")] private var T5:Class;
		[Embed(source = "/../res/T_6.png")] private var T6:Class;
		[Embed(source = "/../res/T_7.png")] private var T7:Class;
		[Embed(source = "/../res/T_8.png")] private var T8:Class;
		var images:Array = new Array( T0, T1, T2, T3, T4, T5, T6, T7, T8);
		
		static var data:Array = new Array(
			new Array(0,1,1,1,1,1,2),
			new Array(3,4,4,4,4,4,5),
			new Array(3,4,4,4,4,4,5),
			new Array(3,4,4,4,4,4,5),
			new Array(3,4,4,4,4,4,5),
			new Array(3,4,4,4,4,4,5),
			new Array(6,7,7,7,7,7,8)
			 );
			 
		
		protected var manager:Manager;//manager that simulates server connectio
		
		protected var gameObjects:Dictionary = new Dictionary();//dictionary of manager-handled object
		protected var player:FlxSprite;
		
		protected var managedSprites:FlxGroup = new FlxGroup();
		
		override public function create():void
		{
			FlxG.bgColor = 0xff000000;
			FlxG.worldBounds = new FlxRect(0, 0,  data[0].length * 32, data.length * 32);
			FlxG.mouse.show(cursor);
			
			this.manager = new DummyManager(new LocalManager());
			
			FlxG.camera.zoom = 2;
			for (var y:int = 0; y < data.length; y++ ) {
				for (var x:int = 0; x < data[y].length; x++ ) {
					var b:FlxSprite = new FlxSprite( x * 32, y * 32, images[data[y][x]] );
					this.add(b);
				}
			}
			
			/*
			FlxG.camera.setBounds(
				FlxG.worldBounds.x,
				FlxG.worldBounds.y,
				FlxG.worldBounds.x+FlxG.worldBounds.width,
				FlxG.worldBounds.y+FlxG.worldBounds.height);*/
			this.add(managedSprites);
		}
		
		protected function setPlayer(p:Player):void
		{
			this.player = p;
			//p.clientControlled = true;
			FlxG.camera.follow(player, FlxCamera.STYLE_LOCKON);
		}
		
		override public function update():void
		{
			manager.update();
			this.manager.update();//should do nothing come networked time, but for now it updates game lojyxx
			
			//PARSE EVENTS FROM MANAGER
			var event:Array = this.manager.getGameEvent();
			while (event != null){
				parseEvent(event.splice(0,1)[0],event);
				event = this.manager.getGameEvent();
			}
			
			//MOVEMENT, LOCAL STUFF
			
			super.update();
		}
		
		
		//TODO can you spell duplicate code?
		protected function parseEvent(type:int, args:Array):void
		{
			switch(type) 
			{
				case Manager.event_spawn:
					this.gameObjects[args[0]] = makeGameSprite(args[0], args[1], args[2], args[3])
					if (this.gameObjects[args[0]].type == Player.MSType) {
						setPlayer(this.gameObjects[args[0]]);
					}
					managedSprites.add(this.gameObjects[args[0]]);
				break;
				case Manager.event_update_position:
					this.gameObjects[args[0]].x = args[1];
					this.gameObjects[args[0]].y = args[2];
				break;
				case Manager.event_update_health:
					this.gameObjects[args[0]].hp = args[1];
				break;
				
				default:
				break;
			}
		}	
		
		protected function makeGameSprite(id:int, x:int, y:int, MSID:int ):FlxSprite {
			var f:ManagedFlxSprite = MSLib.getMFlxSprite(MSID,x,y,this.manager,id)
			return f
		}
		
	}
}