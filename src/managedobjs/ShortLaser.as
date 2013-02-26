// ActionScript filepackage managedobjs 
package managedobjs
{	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	
	/**
	 * I RUV ME SOME OBJECTS
	 * @author Maxwell Huang-Hobbs
	 */
	public class ShortLaser extends ManagedFlxSprite
	{
		public static var MSType = 2;
		
		protected var counter:Number = 0;
		
		public function ShortLaser(x:Number, y:Number, parent:Manager, managedID:int)
		{
			super(x, y, parent, managedID, 100);
			this.type = ShortLaser.MSType;
			this.makeGraphic(1,1,FlxG.WHITE);
			this.scale.x=30;
		}
		
		override public function update():void
		{
			super.update();
			counter+=FlxG.elapsed;
			if(counter>0.5 && counter<1.5){
				this.scale.y=7.5-5*counter;
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
				if(FlxG.collide(gameObject,this))
				{
					//PlayState.consoleOutput.text = "COLL";
					this.parent.damage(gameObject,1);
				}
			}
			super.updateTrackedQualities();
		}
		
		
	}

}
		