package managedobjs 
{
	
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Maxwell Huang-Hobbs
	 */
	public class ExampleEnemy extends ManagedFlxSprite
	{
		
		[Embed(source = "/../res/Enemy.png")] private var enemy:Class;
		
		public static var MSType:int = 1;
		public static var movespeed:Number = 30;
		
		public function ExampleEnemy(x:Number, y:Number, parent:Manager, managedID:int) 
		{
			super(x, y, parent, managedID, 10);
			this.type = ExampleEnemy.MSType;
			loadGraphic(enemy, true, true, 11, 15);
			this.replaceColor(0xffff00ff, 0x00ffffff);
			
			addAnimation("stnd", [5,6], 4, true);
			addAnimation("walk", [0, 1, 2, 3, 4, 5], 10, true);
			play("stnd");
			this.drag.x = movespeed / 10;
			this.drag.y = movespeed / 10;
			
		}
		
		override public function update():void {
			super.update();

			if (this.velocity.x != 0 || this.velocity.y != 0)
			{
				play("walk");
			}
			else
			{
				play("stnd");
			}
			
			if (this.velocity.x < 0) {
				this.facing = 1;
			}
			if (this.velocity.x > 0) {
				this.facing = 0;
			}
			
		}
		
		override public function updateTrackedQualities():void {
			var p:ManagedFlxSprite = this.parent.getPlayer();//TODO this...
			var hyp:Number = Math.sqrt( Math.pow(p.x - this.x, 2) + Math.pow(p.y - this.y, 2));
			if(hyp>1){
				var cos = (p.x - this.x) / hyp, sin = (p.y - this.y) / hyp;
				
				this.velocity.x = cos * movespeed;
				this.velocity.y = sin * movespeed;
			}
			super.updateTrackedQualities();
			
		}
		
	}

}