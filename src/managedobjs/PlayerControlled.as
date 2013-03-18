package managedobjs
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	import managers.Manager;
	
	import archetypes.ArchetypeMage;
	import archetypes.ArchetypeWarrior;
	
	public class PlayerControlled extends PlayerDummy
	{
		public static var MSType = 0;
		
		public function PlayerControlled(x:Number, y:Number, parent:Manager, managedID:int)
		{
			super(x, y, parent, managedID);
			this.type=PlayerControlled.MSType;
			if (this.managedID==0) {
				this.archetype = new ArchetypeMage();
			} else if (this.managedID==1) {
				this.archetype = new ArchetypeWarrior();
			} else {
				this.archetype = new ArchetypeMage();
			}
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