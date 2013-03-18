package managedobjs 
{	
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.FlxSprite;
	import managers.Manager;
	
	
	/**
	 * I RUV ME SOME OBJECTS
	 * @author Maxwell Huang-Hobbs
	 */
	public class PlayerDummy extends ManagedFlxSprite
	{
		
		public static var MSType:int = 5;
		
		protected static var moveSpeed:Number = 100;
		protected static var diagMovespeed:Number = Math.sqrt(2) / 2 * moveSpeed;
		protected static var dragValue:Number = 16*moveSpeed;
		protected static var dashSpeed:Number = 2;
		
		protected var channeling:Boolean = false;
		protected var stopMotion:Boolean = false;
		
		protected var lastDamage = 0;
		protected static var damageRefreshTime = 0.25;
		
		[Embed(source = "/../res/Mage.png")] private var playerSprite:Class;
		[Embed(source="/../res/laser_fire.mp3")] private var laserSound:Class;
		
		public function PlayerDummy(x:Number, y:Number, parent:Manager, managedID:int) 
		{
			super(x, y, parent, managedID, 10);
			this.clientControlled = true;
			this.align=Manager.align_friend;
			
			this.type = PlayerDummy.MSType;
			this.makeGraphic(10, 12, 0xffaa1111);
			this.maxVelocity.x = moveSpeed*2;
			this.maxVelocity.y = moveSpeed * 2;
			
			loadGraphic(playerSprite, true, true, 11, 15);
			this.replaceColor(0xffff00ff, 0x00ffffff);
			addAnimation("stnd", [0], 10, true);
			addAnimation("walk", [1, 2, 3, 2], 5, true);
			addAnimation("shot", [9,10,10,10,11,11,10,12,12], 10, false);
			addAnimation("roll", [18,19,20,21,22,23,24,25,26,26], 25, false);
			addAnimation("cast", [14,15,16,17,16,16,16,16,15,14,14], 20, false);
			addAnimation("ulti", [27,28,29,30,30,30,30,29,28,31,31], 20, false);
			play("stnd");
			this.facing = 0;//turn around
		}
		
		override public function update():void {
			super.update();
			lastDamage += FlxG.elapsed;
			
			if (this._curAnim.name == "walk" || this._curAnim.name == "stnd" || 
				(!this._curAnim.looped && this._curFrame==this._curAnim.frames.length-1) ){
				this.channeling = false;
				
				if (this._curAnim.name == "roll") {
					if (this.displayDebuffIcons[DebuffHandler.INVULN]) {
						this.removeDebuff(DebuffHandler.INVULN)
					}
				}
				
				if (this.velocity.x != 0 || this.velocity.y != 0) {
					play("walk");
				}
				else {
					play("stnd");
				}
			}
		}
		
		
		
		override public function damage( dmg:int ){
			if(this.lastDamage>PlayerDummy.damageRefreshTime){
				this.lastDamage=0;
				super.damage(dmg);
			}
		}
		
	}

}