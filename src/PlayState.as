package  
{
	import flash.net.GroupSpecifier;
	import flash.utils.Dictionary;
	
	import managedobjs.*;
	
	import org.flixel.*;
	
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
			 
		
		public var manager:Manager;//manager that simulates server connectio
		
		public var player:FlxSprite;
		
		public var managedSprites:FlxGroup = new FlxGroup();
		
		public static var consoleOutput:FlxText;
		
		override public function create():void
		{
			PlayState.consoleOutput = new FlxText(0,0,100,"START");
			
			FlxG.bgColor = 0xff000000;
			FlxG.worldBounds = new FlxRect(0, 0,  data[0].length * 32, data.length * 32);
			FlxG.mouse.show(cursor);
			
			this.manager = new DummyManager(new LocalManager(),this);
			
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
			
			this.add(PlayState.consoleOutput);
		}
		
		public function setPlayer(p:Player):void
		{
			this.player = p;
			//p.clientControlled = true;
			FlxG.camera.follow(player, FlxCamera.STYLE_LOCKON);
		}
		
		override public function update():void
		{
			
			manager.update();
			this.manager.update();//should do nothing come networked time, but for now it updates game lojyxx
			
			//MOVEMENT, LOCAL STUFF
			
			super.update();
		}
		
	}
}