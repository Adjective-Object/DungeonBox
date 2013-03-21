// ActionScript filepackage managedobjs 
package managedobjs
{	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	
	import managedobjs.MSLib;
	import managers.Manager;
	
	
	/**
	 * I RUV ME SOME OBJECTS
	 * @author Maxwell Huang-Hobbs
	 */
	public class ShortLaser extends ManagedFlxSprite
	{
		public static var MSType = 2;
		public static var laserLength = 60, waitTime = 0.2, chargeTime = 0.2, fireTime = 0.1;
		
		protected var counter:Number = 0;
		
		protected var collidedWith:Array = new Array(), collisionRecord:Array = new Array();
		
		public function ShortLaser(x:Number, y:Number, parent:Manager, managedID:int, damage:int=1)
		{
			super(x, y, parent, managedID, 100);
			this.type = ShortLaser.MSType;
			this.makeGraphic(laserLength,1,FlxG.WHITE);
			this.scale.y = 1;
			this.width = laserLength;
			this.height = 5;
			this.offset.y = -2.5;
			
			this.setState(damage);
		}
		
		override public function update():void
		{
			super.update();
			counter += FlxG.elapsed;
			if (counter > chargeTime && counter < chargeTime+waitTime) {
				this.scale.y = (this.counter-waitTime)*(1/chargeTime);
			}
			else if(counter>chargeTime+waitTime && counter<chargeTime+waitTime+fireTime){
				this.scale.y=5-5*(counter-(chargeTime+waitTime)) / fireTime ;
			}
			else if(counter>=chargeTime+waitTime+fireTime){
				this.kill();
				//this.visible = false;
			}
			//updateTrackedQualities();
		}
		
		override public function updateTrackedQualities():void
		{
			if(this.counter>waitTime+chargeTime){
				for each( var gameObject:ManagedFlxSprite in parent.getAllSprites().members)
				{
					if( gameObject!=null && gameObject.align != this.align && gameObject.align!=Manager.align_none && !collisionRecord[gameObject.managedID] && MSLib.overlap(this, gameObject))
					{
						collisionRecord[gameObject.managedID] = true;
						gameObject.damage( this.state );
						if(this.facing==0){
							this.parent.knockBack(gameObject, 30, 0);
						}
						else if (this.facing==1){
							this.parent.knockBack(gameObject,-30,0);
						}
					}
				}
			}
			super.updateTrackedQualities();
		}
		
		
	}

}
		