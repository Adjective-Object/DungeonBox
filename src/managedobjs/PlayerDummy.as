package managedobjs 
{	
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.FlxSprite;
	import archetypes.*;
	import managers.Manager;
	
	import items.Item;
	
	/**
	 * I RUV ME SOME OBJECTS
	 * @author Maxwell Huang-Hobbs
	 */
	public class PlayerDummy extends ManagedFlxSprite
	{	
		public static var MSType:int = 5;
		
		var inventory:Array = new Array();
		var useItem:Item;
				
		public var lastDamage = 0;
		public static var damageRefreshTime = 0.25;
		
		protected var archetype:Archetype = new ArchetypeMage();
		
		public function PlayerDummy(x:Number, y:Number, parent:Manager, managedID:int, archetypeID:uint= -1) 
		{
			super(x, y, parent, managedID, 10);
			this.align=Manager.align_friend;
			
			this.type = PlayerDummy.MSType;
			this.makeGraphic(10, 12, 0xffaa1111);
			if( archetypeID!=-1 ){
				this.setState(archetypeID);
			}
		}
		
		override public function setState(archetypeID:int):void{
			switch(archetypeID)
			{
				case 0:
					this.archetype = new ArchetypeWarrior();
					break
				case 1:
					this.archetype = new ArchetypeMage();
					break;
				default:
					this.archetype = new ArchetypeMage();
					break;
			}
			
			//ARCHETYPE USE
			this.maxVelocity.x = archetype.moveSpeed*2;
			this.maxVelocity.y = archetype.moveSpeed * 2;
			this.archetype.defineAnimations(this)
			this.facing = 0;//turn around
		}
		
		override public function update():void {
			super.update();
			lastDamage += FlxG.elapsed;
			
			this.archetype.update(this);
		}
		
		public function addItem(p:Item){
			if(!p.isUseItem && !p.isConsumable){
				p.setOwner(this);
				inventory.push(p);
			}
			else if (p.isUseItem){ 
				this.useItem=p;
				this.useItem.setOwner(this);
			}
		}
		
		override public function damage( dmg:int ){
			if(dmg>=0 && this.lastDamage>PlayerDummy.damageRefreshTime){
				this.lastDamage=0;
				super.damage(dmg);
			} else if (dmg<0){
				super.damage(dmg);
			}
		}
		
	}

}