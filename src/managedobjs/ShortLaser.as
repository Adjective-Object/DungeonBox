// ActionScript filepackage managedobjs 
package managedobjs
{	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	
	
	/**
	 * I RUV ME SOME OBJECTS
	 * @author Maxwell Huang-Hobbs
	 */
	public class ShortLaser extends ManagedFlxSprite
	{
		public static var MSType = 2;
		
		protected var counter:Number = 0;
		
		protected var collidedWith:Array = new Array(), collisionRecord:Array = new Array();
		
		public function ShortLaser(x:Number, y:Number, parent:Manager, managedID:int)
		{
			super(x, y, parent, managedID, 100);
			this.type = ShortLaser.MSType;
			this.makeGraphic(1,1,FlxG.WHITE);
			this.scale.x = 30;
			this.scale.y = 0;
			FlxG.overlap(this, parent.getAllSprites(), onCollide);
		}
		
		override public function update():void
		{
			super.update();
			counter += FlxG.elapsed;
			if (counter > 0.2 && counter < 0.5) {
				this.scale.y = (this.counter-0.2)*(1/0.3);
			}
			if(counter>0.5 && counter<1.5){
				this.scale.y=5-5*(counter-0.5);
			}
			else if(counter>=1.5){
				this.kill();
			}
		}
		
		override public function updateTrackedQualities():void
		{
			this.makeGraphic(1,1,FlxG.RED);
			for each( var gameObject:ManagedFlxSprite in parent.getAllSprites())
			{
				if(collidedWith[gameObject.managedID] && !collisionRecord[gameObject.managedID] )
				{
					collisionRecord[gameObject.managedID] = true;
					PlayState.consoleOutput.text = "COLL";
					this.parent.damage(gameObject, 1);
				}
			}
			super.updateTrackedQualities();
		}
		
		public function onCollide(Object1:FlxObject,Object2:FlxObject):void {
			collidedWith[Object2] = true;
		}
		
		
	}

}
		