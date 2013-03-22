package
{
	import flash.system.System;
	
	import org.flixel.*;
	
	public class MenuState extends FlxState
	{
		
		protected static var menuheight1:int = 180;	
		protected static var menuheight2:int = 200;		
		protected static var menuheight3:int = 220;	
		
		protected var focus:uint = 0;
		
		protected var texts:Array = new Array();
		
		override public function create():void
		{
			var title:FlxText;
			title = new FlxText(0, 16, FlxG.width, "Dungeon Box");
			title.setFormat (null, 20, 0xFFFFFFFF, "center");
			add(title);
			
			var hostgame:FlxText;
			hostgame = new FlxText(0, menuheight1, FlxG.width, "Host a game");
			hostgame.setFormat (null, 12, 0xFFFFFFFF, "center");
			add(hostgame);
			texts.push(hostgame);
			
			var connectgame:FlxText;
			connectgame = new FlxText(0, menuheight2, FlxG.width, "Connect to a game");
			connectgame.setFormat (null, 12, 0xFFFFFFFF, "center");
			add(connectgame);
			texts.push(connectgame);
			
			var quitgame:FlxText;
			quitgame = new FlxText(0, menuheight3, FlxG.width, "Quit");
			quitgame.setFormat (null, 12, 0xFFFFFFFF, "center");
			add(quitgame);
			texts.push(quitgame);
			
			var instructions:FlxText;
			instructions = new FlxText(0, FlxG.height - 44, FlxG.width, "up / down to move cursor");
			instructions.setFormat (null, 8, 0xFFFFFFFF, "center");
			add(instructions);
			
			var instructions2:FlxText;
			instructions2 = new FlxText(0, FlxG.height - 32, FlxG.width, "Press space / enter to select");
			instructions2.setFormat (null, 8, 0xFFFFFFFF, "center");
			add(instructions2);
			
			doColors();
			
		} // end function create
		
		function doColors(){
			for(var i:int = 0; i<texts.length; i++){
				if(focus==i){
					texts[i].color = 0x00ffff;
				} else{
					texts[i].color = 0xffffff
				}
			}
		}
		
		override public function update():void
		{
			super.update(); // calls update on everything you added to the game loop
			
			var up:Boolean = FlxG.keys.justPressed("UP");
			var down:Boolean = FlxG.keys.justPressed("DOWN");
			if ( up || down )
			{
				if(up){
					focus = (focus-1)%texts.length;
				} if(down){
					focus = (focus+1)%texts.length;
				}
				
				doColors();
			}
			
			
			if (FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("ENTER"))
			{
				switch(focus){
					case 0:
						FlxG.switchState( new HostLobby() );
						break;
					case 1:
						//FlxG.switchState(new PlayState(false));
						break;
					case 2:
						System.exit(0);
						break;
				}
			}
			
		} // end function update
		
		
		public function MenuState()
		{
			super();
			
		}  // end function MenuState
		
	} // end class
}// end package 
