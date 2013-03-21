package archetypes
{
	import managedobjs.DebuffHandler;
	import managedobjs.PlayerControlled;
	import managedobjs.PlayerDummy;
	import managedobjs.WarriorSlash;
	import managedobjs.BurnAOE;
	import managedobjs.GravityWell;
	import managedobjs.DebuffHandler;
	
	import managers.Manager;
	
	import org.flixel.FlxG;
	
	public class ArchetypeWarrior extends Archetype
	{
		
		[Embed(source = "/../res/Warrior.png")] private var playerSprite:Class;
		[Embed(source="/../res/laser_fire.mp3")] private var laserSound:Class;
		
		public var channeling:Boolean = false;
		public var stopMotion:Boolean = false;
		
		public override function defineAnimations(player:PlayerDummy):void{
			player.loadGraphic(playerSprite, true, true, 19, 15);
			player.replaceColor(0xffff00ff, 0x00ffffff);
			player.replaceColor(0xffaa00aa, 0x00ffffff);
			
			player.addAnimation("stnd", [0], 10, true);
			player.addAnimation("walk", [1, 2, 3, 2], 5, true);
			
			player.addAnimation("shot", [5, 5, 5, 5, 6, 7, 8, 7, 7], 15, false);
			player.addAnimation("cast", [10, 10, 10, 10, 12, 13, 14, 15, 15, 16, 17, 17], 15, false);
			player.addAnimation("roll", [1, 2, 3, 2], 5, false);
			player.addAnimation("ulti", [41, 41, 42, 43, 44, 45, 44, 44], 15, false);
			
			player.addAnimation("sla1", [5, 5, 5, 5, 6, 7, 8, 7, 7], 15, false);
			player.addAnimation("sla2", [10, 10, 10, 10, 12, 13, 14, 15, 15, 16, 17, 17], 15, false);
			player.addAnimation("sla3", [41, 41, 42, 43, 44, 45, 44, 44], 15, false);
			player.play("stnd");
		}
		
		public override function update(player:PlayerDummy):void{
			if (player.getCurAnim().name == "walk" || player.getCurAnim().name == "stnd" || 
				(!player.getCurAnim().looped && player.getCurFrame()==player.getCurAnim().frames.length-1) ){
				this.channeling = false;
				
				if (player.getCurAnim().name == "roll") {
					if (player.displayDebuffIcons[DebuffHandler.INVULN]) {
						player.removeDebuff(DebuffHandler.INVULN);
					}
				}
				
				if (player.velocity.x != 0 || player.velocity.y != 0) {
					player.play("walk");
				}
				else {
					player.play("stnd");
				}
			}
		}
		
		protected var chainedCasts:uint = 0;
		protected var elapsedSinceCast:Number = 0;
		protected static var castResetTime = 0.75;
		
		public override function updateTracked(player:PlayerControlled):void{
			this.elapsedSinceCast+=FlxG.elapsed;
			if(elapsedSinceCast>castResetTime && chainedCasts>0){
				trace(chainedCasts);
				chainedCasts=0;
				player.cooldowns[0]=5;
			}
			if (!channeling) {
				this.stopMotion = true;
			}
			
			if ((FlxG.keys.LEFT || FlxG.keys.RIGHT) && !this.channeling) {
				player.drag.x = 0;
			}
			else if (this.stopMotion) { player.velocity.x = 0; }
			
			if ( (FlxG.keys.UP || FlxG.keys.DOWN) && !this.channeling) {
				player.drag.y = 0;
			}
			else if (this.stopMotion) { player.velocity.y = 0; }
			
			if (!this.channeling) {//only if is taking actions right now
				//movement;
				
				
				if (FlxG.keys.LEFT)
				{
					player.velocity.x = -moveSpeed
						player.facing = 1;//turn around
				}
				if (FlxG.keys.RIGHT)
				{
					player.velocity.x = moveSpeed
					player.facing = 0;//turn around
				}
				if (FlxG.keys.UP)
				{
					player.velocity.y=-moveSpeed
				}
				if (FlxG.keys.DOWN)
				{
					player.velocity.y=moveSpeed
				}
				
				if (FlxG.keys.Q && player.cooldowns[0]==0)
				{
					if(elapsedSinceCast>castResetTime){
						this.chainedCasts=0;
					}
					
					var damage:int;
					
					switch(chainedCasts){
						case 0:
							player.play("sla1");
							damage=1;
							break;
						case 1:
							player.play("sla3");
							damage=2;
							break;
						case 2:
							player.play("sla2");
							damage=3;
							break;
						default:
							player.play("sla1");
							damage=10;
							trace("panic!");
							break
					}
					
					this.channeling = true;
					this.stopMotion = true;
					
					//TODO differentiate from mage
					var s:WarriorSlash;
					if(player.facing == 0){//right
						s = new WarriorSlash(player.x+player.width, player.y, player.parent, null, 3+this.chainedCasts );
					} else {//left
						s = new WarriorSlash(player.x-WarriorSlash.width, player.y, player.parent, null, this.chainedCasts);
					}
					s.align=Manager.align_friend;
					player.parent.spawn(s);
					
					
					this.chainedCasts++;
					if(this.chainedCasts==3){
						this.chainedCasts=0
					}
					this.elapsedSinceCast=0;
				}
					
				else if (FlxG.keys.W && player.cooldowns[1]==0)
				{
					player.cooldowns[1]=8;
					player.play("cast");
					this.channeling = true;
					this.stopMotion = true;
					var b:BurnAOE;
					if(player.facing == 0){
						b = new BurnAOE(player.getMidpoint().x + BurnAOE.distancePlaced - BurnAOE.nullWidth/2, player.getMidpoint().y-3, player.parent, null);
						b.facing = 0;
					} else {
						b = new BurnAOE(player.getMidpoint().x - BurnAOE.distancePlaced - BurnAOE.nullWidth/2 , player.getMidpoint().y - 3, player.parent, null);
						b.facing = 1;
					}
					b.align = Manager.align_friend;
					player.parent.spawn(b);
				}
				
				else if (FlxG.keys.E  && player.cooldowns[2]==0)
				{
					player.cooldowns[2]=2;
					player.play("roll");
					this.stopMotion = false;
					this.channeling = true;
					if (!player.displayDebuffIcons[DebuffHandler.INVULN]) {
						player.applyDebuff(DebuffHandler.INVULN);
					}
					
					if (FlxG.keys.LEFT || FlxG.keys.RIGHT || FlxG.keys.UP || FlxG.keys.DOWN) {
						player.velocity.x = player.velocity.x * dashSpeed;
						player.velocity.y = player.velocity.y * dashSpeed;
					} else {
						if (player.facing){ player.velocity.x = -moveSpeed * dashSpeed; }
						else { player.velocity.x = moveSpeed * dashSpeed; }
						player.drag.x = 0;
						player.drag.y = 0;
					}
				}
					
				else if (FlxG.keys.R && player.cooldowns[3]==0)
				{
					player.cooldowns[3]=15;
					trace(player.parent);
					player.play("ulti");
					this.channeling = true;
					var g = new GravityWell(player.getMidpoint().x, player.getMidpoint().y, player.parent, null);
					g.align=Manager.align_friend;
					g.spawn();
				}
			}
			
		}
	}
}