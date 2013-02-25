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
		
		protected var manager:LocalManager;
		protected var gameObjects:Dictionary = new Dictionary();//dictionary of manager-handled object
		protected var player:FlxSprite;
		
		protected var managedSprites:FlxGroup = new FlxGroup();
		
		override public function create():void
		{
			FlxG.bgColor = 0xff4a515c;
			FlxG.worldBounds = new FlxRect(0,0,Manager.mapSize.x, Manager.mapSize.y);
			
			this.manager = new LocalManager(true);
			
			FlxG.camera.zoom = 2;
			this.add(managedSprites);
		}
		
		protected function setPlayer(p:Player):void
		{
			this.player = p;
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
			
			//GENERATE EVENTS AND REPORT THEM TO THE MANAGER
			
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
				trace(args);
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