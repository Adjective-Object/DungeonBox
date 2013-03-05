package managers  
{
	
	import flash.utils.Dictionary;
	
	import managedobjs.MSLib;
	import managedobjs.Player;
	import managedobjs.DebuffHandler;
	
	
	import org.flixel.*;
	
	/**
	 * Simulates Client-server connection
	 * @author Maxwell Huang-Hobbs
	 */
	public class ClientManager extends Manager
	{
		
		protected var gameObjects:FlxGroup = new FlxGroup();//dictionary of manager-handled object
		private var child:PlayState;
		
		public function ClientManager(child:PlayState) 
		{	
			super();
			this.clientSide = true;
			this.child = child;
		}
		
		override public function update():void
		{	
			//PARSE EVENTS FROM MANAGER
			
			var event:Array = this.getGameEvent();
			while (event != null){
				parseEvent(event.splice(0,1)[0],event);
				event = this.getGameEvent();
			}
		}

		//TODO can you spell duplicate code?
		protected function parseEvent(type:int, args:Array):void
		{
			switch(type) 
			{
				case Manager.event_spawn:
					this.gameObjects.members[args[0]] = makeGameSprite(args[0], args[1], args[2], args[3], args[4], args[5])
					if (this.gameObjects.members[args[0]].type == Player.MSType) {
						this.child.setPlayer(this.gameObjects.members[args[0]]);
						this.child.add(this.gameObjects.members[args[0]]);
					} else{
						this.child.managedSprites.add(this.gameObjects.members[args[0]]);
					}
					
					break;
				case Manager.event_kill:
					this.child.remove(this.gameObjects.members[args[0]]);
					delete this.gameObjects.members[args[0]];
					break;
				case Manager.event_update_position:
					this.gameObjects.members[args[0]].x = args[1];
					this.gameObjects.members[args[0]].y = args[2];
					break;
				case Manager.event_update_animation:
					this.gameObjects.members[args[0]].play(args[1]);
					this.gameObjects.members[args[0]].facing = args[2];
					break;
				case Manager.event_update_health:
					this.gameObjects.members[args[0]].hp = args[1];
					break;
				case Manager.event_damage:
					this.child.add(new DamageText(gameObjects.members[args[0]].x, gameObjects.members[args[0]].y, args[1], gameObjects.members[args[0]].align));
					break;
				case Manager.event_debuff:
					if (args[2] == 0) {
						DebuffHandler.removeDebuff(this.gameObjects.members[args[0]], args[1]);
					}else {
						DebuffHandler.applyDebuff(this.gameObjects.members[args[0]], args[1]);
					}
				break;
				default:
					break;
			}
		}	
		
		protected function makeGameSprite(id:int, x:int, y:int, MSID:int, align:int, facing:int ):FlxSprite {
			var f:ManagedFlxSprite = MSLib.getMFlxSprite(MSID,x,y,this,id);
			f.facing = facing;
			f.align=align;
			return f
		}
		
		public override function getEntity( id:uint):ManagedFlxSprite
		{
			return this.gameObjects.members[id];
		}
		public override function getAllSprites():FlxGroup {
			return this.gameObjects;
		}
		
		//#####################ohgfuck
		
		public override function spawn( e:ManagedFlxSprite):void
		{
			reportEvent(Manager.getSpawnEvent(e));
		}
		public override function updatePosition( e:ManagedFlxSprite):void
		{
			this.reportEvent(Manager.getUpdatePosEvent(e));
		}
		public override function updateHealth( e:ManagedFlxSprite):void
		{
			this.reportEvent(Manager.getUpdateHPEvent(e));
		}
		public override function updateAnimation( e:ManagedFlxSprite):void
		{
			this.reportEvent(Manager.getUpdateAnimEvent(e));
		}
		public override function kill( e:ManagedFlxSprite):void
		{
			this.reportEvent(Manager.getKillEvent(e));
		}
		public override function damage( e:ManagedFlxSprite, damage:int ):void
		{
			this.reportEvent(Manager.getDamageEvent(e,damage));
		}
		public override function applyDebuff( e:ManagedFlxSprite, debuffID:int ):void
		{
			this.reportEvent( Manager.getDebuffEvent(e,debuffID) );
		}
		public override function removeDebuff( e:ManagedFlxSprite, debuffID:int ):void
		{
			this.reportEvent( Manager.getDebuffClearEvent(e,debuffID) );
		}
		
	}

}