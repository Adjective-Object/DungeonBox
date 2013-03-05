package managedobjs 
{	
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.FlxSprite;
	
	
	/**
	 * I RUV ME SOME OBJECTS
	 * @author Maxwell Huang-Hobbs
	 */
	public class Player extends ManagedFlxSprite
	{
		
		public static var MSType:int = 0;
		
		protected static var moveSpeed:Number = 100;
		protected static var diagMovespeed:Number = Math.sqrt(2) / 2 * moveSpeed;
		protected static var dragValue:Number = 16*moveSpeed;
		protected static var dashSpeed:Number = 2;
		
		protected var channeling:Boolean = false;
		protected var stopMotion:Boolean = false;
		
		[Embed(source = "/../res/Mage.png")] private var playerSprite:Class;
		[Embed(source="/../res/laser_fire.mp3")] private var laserSound:Class;
		
		public function Player(x:Number, y:Number, parent:Manager, managedID:int) 
		{
			super(x, y, parent, managedID, 10);
			this.clientControlled = true;
			this.align=Manager.align_friend;
			
			this.type = Player.MSType;
			this.makeGraphic(10, 12, 0xffaa1111);
			this.maxVelocity.x = moveSpeed*2;
			this.maxVelocity.y = moveSpeed * 2;
			
			loadGraphic(playerSprite, true, true, 11, 15);
			this.replaceColor(0xffff00ff, 0x00ffffff);
			addAnimation("stnd", [0], 10, true);
			addAnimation("walk", [1, 2, 3, 2], 5, true);
			addAnimation("shot", [9,10,10,10,11,11,10,12,12], 10, false);
			addAnimation("roll", [18,19,20,21,22,23,24,25,26,26], 25, false);
			addAnimation("cast", [14,15,16,17,16,16,16,16,15,14,14], 20, false);
			addAnimation("ulti", [27,28,29,30,30,30,30,29,28,31,31], 20, false);
			play("stnd");
			this.facing = 0;//turn around
		}
		
		override public function update():void {
			super.update();
			
			if (this._curAnim.name == "walk" || this._curAnim.name == "stnd" || 
				(!this._curAnim.looped && this._curFrame==this._curAnim.frames.length-1) ){
				this.channeling = false;
				
				if (this._curAnim.name == "roll") {
					if (this.displayDebuffIcons[DebuffHandler.INVULN]) {
						this.removeDebuff(DebuffHandler.INVULN)
					}
				}
				
				if (this.velocity.x != 0 || this.velocity.y != 0) {
					play("walk");
				}
				else {
					play("stnd");
				}
			}
		}
		
		override public function updateTrackedQualities():void {
				
			if (!channeling) {
				this.stopMotion = true;
			}
			
			if ((FlxG.keys.LEFT || FlxG.keys.RIGHT) && !this.channeling) {
				this.drag.x = 0; 
			}
			else if (this.stopMotion) { this.velocity.x = 0; }
				
			if ( (FlxG.keys.UP || FlxG.keys.DOWN) && !this.channeling) {
				this.drag.y = 0;
			}
			else if (this.stopMotion) { this.velocity.y = 0; }
				
			if (!this.channeling) {//only if is taking actions right now
				//movement;
				
			
				if (FlxG.keys.LEFT)
				{
					this.velocity.x = -moveSpeed
					this.facing = 1;//turn around
				}
				if (FlxG.keys.RIGHT)
				{
					this.velocity.x = moveSpeed
					this.facing = 0;//turn around
				}
				if (FlxG.keys.UP)
				{
					this.velocity.y=-moveSpeed
				}
				if (FlxG.keys.DOWN)
				{
					this.velocity.y=moveSpeed
				}
				
				if (FlxG.keys.Q)
				{
					play("shot");
					this.channeling = true;
					this.stopMotion = true;
					var s:ShortLaser;
					if(facing == 0){
						s = new ShortLaser(this.x+this.width, this.getMidpoint().y-3, this.parent, null);
						s.facing = 0;
					} else {
						s = new ShortLaser(this.x-ShortLaser.laserLength, this.getMidpoint().y-3, this.parent, null);
						s.facing = 1;
					}
					s.align=Manager.align_friend;
					this.parent.spawn(s);
				}
				
				else if (FlxG.keys.W)
				{
					play("roll");
					this.stopMotion = false;
					this.channeling = true;
					if (!this.displayDebuffIcons[DebuffHandler.INVULN]) {
						this.applyDebuff(DebuffHandler.INVULN);
					}
					
						if (FlxG.keys.LEFT || FlxG.keys.RIGHT || FlxG.keys.UP || FlxG.keys.DOWN) {
						this.velocity.x = this.velocity.x * dashSpeed;
						this.velocity.y = this.velocity.y * dashSpeed;
					} else {
						if (facing){ this.velocity.x = -moveSpeed * dashSpeed; }
						else { this.velocity.x = moveSpeed * dashSpeed; }
						this.drag.x = 0;
						this.drag.y = 0;
					}
				}
				
				else if (FlxG.keys.E)
				{
					play("cast");
					this.channeling = true;
					this.stopMotion = true;
					var b:BurnAOE;
					if(facing == 0){
						b = new BurnAOE(this.getMidpoint().x + BurnAOE.distancePlaced - BurnAOE.nullWidth/2, this.getMidpoint().y-3, this.parent, null);
						b.facing = 0;
					} else {
						b = new BurnAOE(this.getMidpoint().x - BurnAOE.distancePlaced - BurnAOE.nullWidth/2 , this.getMidpoint().y - 3, this.parent, null);
						b.facing = 1;
					}
					b.align = Manager.align_friend;
					this.parent.spawn(b);
				}
				
				else if (FlxG.keys.R)
				{
					trace(this.parent);
					play("ulti");
					this.channeling = true;
					var g = new GravityWell(this.getMidpoint().x, this.getMidpoint().y, this.parent, null);
					g.align=Manager.align_friend;
					g.spawn();
				}
			}
			
			super.updateTrackedQualities();
		}
		
		override public function postUpdate():void {
			super.postUpdate();
			if (this.x < FlxG.worldBounds.left) 	{ this.x = FlxG.worldBounds.left;  }
			if (this.y < FlxG.worldBounds.top) 		{ this.y = FlxG.worldBounds.top;   }
			if (this.x+this.width  > FlxG.worldBounds.right) 	{ this.x = FlxG.worldBounds.right-this.width; }
			if (this.y+this.height > FlxG.worldBounds.bottom) 	{ this.y = FlxG.worldBounds.bottom-this.height;}
		}
		
	}

}