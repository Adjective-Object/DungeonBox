package managedobjs
{
	import HUDItems.HUDImage;
	
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
		var useItem:Item;
		var useItemSprite:HUDImage;
		
		public static var MSType = 0;
		
		public var pstate:PlayState;
		
		public var cooldowns:Array;
		
		public function PlayerControlled(x:Number, y:Number, parent:Manager, managedID:int)
		{
			super(x, y, parent, managedID);
			this.type=PlayerControlled.MSType;
			//defining archetype of player
			cooldowns = new Array(0,0,0,0,0);//Q, W , E, R, and use item (D).
		}
		
		override public function updateTrackedQualities():void {
			for(var i:int =0; i<cooldowns.length; i++){
				cooldowns[i]-=FlxG.elapsed;
				if(cooldowns[i]<0){
					cooldowns[i]=0;
				}
			}
			
			this.archetype.updateTracked(this);
			
			if(this.cooldowns[4]==0 && FlxG.keys.D){
				this.useItem.onUse();
			}
			
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
			if(!p.isUseItem && !p.isConsumable){
				p.setOwner(this);
				var d:HUDImage = new HUDImage(10,10+35*inventory.length,p.image);
				d.alpha=0.7;
				
				this.pstate.add(d);
				inventory.push(p);
				inventorySprites.push(d)
			}
			else if (p.isUseItem){ //mutual exlcusivity of use items
				if(this.useItem!=null){
					new ItemOnGround(this.x,this.y,this.parent,this.useItem.type).spawn();
				}
				this.useItem=p;
				this.useItem.setOwner(this);
				var d:HUDImage = new HUDImage(35,10,this.useItem.image);
				d.alpha=0.7;
				this.pstate.remove(this.useItemSprite);
				this.useItemSprite=d;
				this.pstate.add(d);
			}
			
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