package managers  
{
	
	import flash.utils.Dictionary;
	
	import managedobjs.DebuffHandler;
	import managedobjs.MSLib;
	import managedobjs.PlayerControlled;
	
	import org.flixel.*;
	
	/**
	 * Simulates Client-server connection
	 * @author Maxwell Huang-Hobbs
	 */
	public class ClientManager extends Manager
	{
		
		protected var gameObjects:FlxGroup = new FlxGroup();//dictionary of manager-handled object
		private var child:PlayState;
		protected var gameEvents:Array = new Array();
		
		public function ClientManager(child:PlayState) 
		{	
			super();
			this.clientSide = true;
			this.child = child;
		}
		
		override public function update():void
		{	
			//PARSE EVENTS
			
			var event:Array = this.getGameEvent();
			while (event != null){
				parseEvent(event);
				event = this.getGameEvent();
			}
		}
		
		//TODO can you spell duplicate code?
		protected function parseEvent(event:Array):void
		{
			switch(event[0])
			{
				case Manager.event_spawn:
					trace("spawnin",event);
					this.gameObjects.members[event[1]] = makeGameSprite(event[1], event[2], event[3], event[4], event[5], event[6])
					if (this.gameObjects.members[event[1]].type == PlayerControlled.MSType) {
						this.child.setPlayer(this.gameObjects.members[event[1]]);
						this.child.add(this.gameObjects.members[event[1]]);
					} else{
						this.child.managedSprites.add(this.gameObjects.members[event[1]]);
					}
					
					break;
				case Manager.event_kill:
					delete this.child.managedSprites.remove(this.gameObjects.members[event[1]]);
					delete this.gameObjects.remove(this.gameObjects.members[event[1]]);
					trace("killing "+event[1]);
					break;
				case Manager.event_update_position:
					this.gameObjects.members[event[1]].x = event[2];
					this.gameObjects.members[event[1]].y = event[3];
					break;
				case Manager.event_update_animation:
					this.gameObjects.members[event[1]].play(event[2]);
					this.gameObjects.members[event[1]].facing = event[3];
					break;
				case Manager.event_update_health:
					this.gameObjects.members[event[1]].hp = event[2];
					break;
				case Manager.event_damage:
					var s = gameObjects.members[event[1]];
					this.child.add(new DamageText(s.x+FlxG.random()*s.width, s.y+FlxG.random()*s.height, event[2], s.align));
					break;
				case Manager.event_debuff:
					if (event[3] == 1) {
						DebuffHandler.applyDebuff(this.gameObjects.members[event[1]], event[2]);
					}else {
						DebuffHandler.removeDebuff(this.gameObjects.members[event[1]], event[2]);
					}
				break;
				default:
					break;
			}
		}	
		
		public override function getGameEvent():Array{
			if(this.gameEvents.length>0){
				return this.gameEvents.splice(0,1)[0];
			}
			else{
				return null;
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