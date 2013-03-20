package managedobjs
{
	import archetypes.ArchetypeMage;
	import archetypes.ArchetypeWarrior;
	
	import items.BlueStone;
	import items.Item;
	
	import managers.Manager;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class PlayerControlled extends PlayerDummy
	{
		var inventory:Array = new Array();
		public var inventorySprites:Array = new Array();
		
		public static var MSType = 0;
		
		public var pstate:PlayState;
		
		public function PlayerControlled(x:Number, y:Number, parent:Manager, managedID:int)
		{
			super(x, y, parent, managedID);
			this.type=PlayerControlled.MSType;
			//defining archetype of player
		}
		
		override public function updateTrackedQualities():void {
			this.archetype.updateTracked(this);
			super.updateTrackedQualities();
			
			for(var i:int=0; i<this.inventory.length; i++){
				this.inventory[i].update();
			}
		}
		
		public function updateItems(event:Array){
			for(var i:int = 0; i<this.inventory.length; i++){
				this.inventory[i].onEvent(event);
			}
		}
		
		public function addItem(p:Item){
			p.setOwner(this);
			var d:FlxSprite = new FlxSprite(FlxG.width/2/FlxG.camera.zoom+10, FlxG.height/2/FlxG.camera.zoom+10 + 32*inventory.length ,p.image);
			d.alpha=0.7;
			d.scrollFactor.x = d.scrollFactor.y = 0;
			
			this.pstate.add(d);
			inventory.push(p);
			inventorySprites.push(d);
			
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