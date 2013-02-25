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
		protected static var dragValue:Number = 8*moveSpeed;
		
		
		[Embed(source="/../res/Mage.png")] private var playerSprite:Class;
		
		public function Player(x:Number, y:Number, parent:Manager, managedID:int) 
		{
			super(x, y, parent, managedID, 10);
			this.type = Player.MSType;
			this.makeGraphic(10, 12, 0xffaa1111);
			this.maxVelocity.x = moveSpeed*2;
			this.maxVelocity.y = moveSpeed * 2;
			
			loadGraphic(playerSprite, true, true, 11, 15);
			addAnimation("stnd", [0], 10, true);
			addAnimation("walk", [1, 2, 3, 2], 5, true);
			play("stnd");
		}
		
		override public function update():void {
			if (FlxG.keys.LEFT || FlxG.keys.RIGHT){ this.drag.x = 0; }
			else { this.drag.x = dragValue; }
			
			if (FlxG.keys.UP || FlxG.keys.DOWN) { this.drag.y = 0; }
			else{ this.drag.y = dragValue; }
			
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
			super.update();
			
			if (this.velocity.x != 0 || this.velocity.y != 0) {
				play("walk");
			}
			else {
				play("stnd");
			}
			
		}
		
		override public function postUpdate():void {
			super.postUpdate();
			if (this.x < FlxG.worldBounds.left) 	{ this.x = FlxG.worldBounds.left;  }
			if (this.y < FlxG.worldBounds.top) 		{ this.y = FlxG.worldBounds.top;   }
			if (this.x > FlxG.worldBounds.right) 	{ this.x = FlxG.worldBounds.right; }
			if (this.y > FlxG.worldBounds.bottom) 	{ this.y = FlxG.worldBounds.bottom;}
		}
		
	}

}