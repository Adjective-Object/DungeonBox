package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;

	/**
	 * FlxSprite subclasses that will report events to Manager when certain things change
	 * 
	 * subclasses should call updateTrackedQualities() instead of update() for game logic loops.
	 * 
	 * 
	 * @author Maxwell Huang-Hobbs
	 */
	public class ManagedFlxSprite extends FlxSprite 
	{
		protected var parent:Manager;
		protected var hp:int, maxHP:int;

		public var managedID:int
		public var type:int;
		
		public static var TYPE_UNDECLARED:int = -1;
		
		protected var hpBar:FlxSprite;
		
		public function ManagedFlxSprite(x:Number, y:Number, parent:Manager, managedID:int, maxHP:int) {
			super(x, y);
			this.parent = parent;
			this.managedID = managedID;
			this.type = ManagedFlxSprite.TYPE_UNDECLARED;//no specifically declared type.
			this.hp = maxHP;
			this.maxHP = maxHP;
			
			if (this.parent.clientSide) {
				this.hpBar = new FlxSprite (0, 0);
				this.hpBar.makeGraphic(15, 3 , 0xffaa1111);
				FlxG.state.add(hpBar);
			}
		}
		
		override public function update():void {
			var tempx:Number = this.x;
			var tempy:Number = this.y;
			var temphp:Number = this.hp;
			
			updateTrackedQualities();
			
			if (this.x != tempx || this.y != tempy) {
				parent.reportEvent( new Array( Manager.event_update_position, this.managedID, this.x, this.y) );
			}
			if (this.hp != temphp) {
				parent.reportEvent( new Array( Manager.event_update_health, this.managedID, this.x, this.y) );
				parent.reportEvent( new Array( Manager.event_damage, this.managedID, temphp-this.hp) );
			}
		}
		
		override public function postUpdate():void {
			super.postUpdate();
			if (this.parent.clientSide) {
				this.hpBar.scale.x = this.hp / this.maxHP;
				this.hpBar.y = this.y-6;
				this.hpBar.x = this.getMidpoint().x - 8;
			}
		}
		
		/**
		 * changes to position, health, and animation to here, so events can be logged by the Manager
		 */
		public function updateTrackedQualities():void {
			super.update();
		}
		
	}

}