package managedobjs
{
	import HUDItems.HUDImage;
	import HUDItems.HUDText;
	
	import archetypes.ArchetypeMage;
	import archetypes.ArchetypeWarrior;
	
	import items.BlueStone;
	import items.Item;
	
	import managers.Manager;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class PlayerControlled extends PlayerDummy
	{
		public var inventorySprites:Array = new Array();
		var useItemSprite:HUDImage;
		
		public static var MSType = 0;
		
		public var pstate:PlayState;
		
		public var cooldowns:Array;
		
		public function PlayerControlled(x:Number, y:Number, parent:Manager, managedID:int, archetypeID:uint = -1)
		{
			super(x, y, parent, managedID, archetypeID);
			this.type=PlayerControlled.MSType;
			this.clientControlled=true;
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
			
			if(this.cooldowns[4]==0 && FlxG.keys.D && this.useItem!=null){
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
		
		public override function addItem(p:Item){
			super.addItem(p);
			this.pstate.add(new HUDText(FlxG.width/FlxG.camera.zoom-110,10,100,p.description,1,"right"));
			if(p.isUseItem){
				var d:HUDImage = new HUDImage(35,10,this.useItem.image);
				d.alpha=0.9;
				if(this.useItemSprite!=null){
					this.pstate.remove(this.useItemSprite);
				}
				this.useItemSprite=d;
				this.pstate.add(d);
			} else{
				var d:HUDImage = new HUDImage(10,10+35*(inventory.length-1),p.image);
				d.alpha=0.7;
				
				inventorySprites.push(d)
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