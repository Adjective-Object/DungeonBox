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
			this.archetype.updateTracked(this);
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