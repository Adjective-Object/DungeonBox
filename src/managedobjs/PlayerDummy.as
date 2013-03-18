package managedobjs 
{	
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.FlxSprite;
	import archetypes.*;
	import managers.Manager;
	
	
	/**
	 * I RUV ME SOME OBJECTS
	 * @author Maxwell Huang-Hobbs
	 */
	public class PlayerDummy extends ManagedFlxSprite
	{
		
		public static var MSType:int = 5;
				
		public var lastDamage = 0;
		public static var damageRefreshTime = 0.25;
		
		protected var archetype:Archetype = new ArchetypeMage();
		
		public function PlayerDummy(x:Number, y:Number, parent:Manager, managedID:int) 
		{
			super(x, y, parent, managedID, 10);
			this.clientControlled = true;
			this.align=Manager.align_friend;
			
			this.type = PlayerDummy.MSType;
			this.makeGraphic(10, 12, 0xffaa1111);
			
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
		
		override public function damage( dmg:int ){
			if(this.lastDamage>PlayerDummy.damageRefreshTime){
				this.lastDamage=0;
				super.damage(dmg);
			}
		}
		
	}

}