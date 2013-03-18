package managedobjs
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import managers.Manager;
	
	public class PlayerControlled extends PlayerDummy
	{
		public static var MSType = 0;
		
		public function PlayerControlled(x:Number, y:Number, parent:Manager, managedID:int)
		{
			super(x, y, parent, managedID);
			this.type=PlayerControlled.MSType;
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