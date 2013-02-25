package  
{
	import flash.geom.Point;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
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
		
		public static function getMSType() { return TYPE_UNDECLARED; }
		
		public static var bar:BitmapData = null;
		
		public function ManagedFlxSprite(x:Number, y:Number, parent:Manager, managedID:int, maxHP:int) {
			super(x, y);
			this.parent = parent;
			this.managedID = managedID;
			this.type = ManagedFlxSprite.TYPE_UNDECLARED;//no specifically declared type.
			this.makeGraphic(10, 12, 0xff11aa11);
			this.hp = maxHP;
			this.maxHP = maxHP;
			this.drag.x = 10;
			if(bar==null){			
				bar = FlxG.createBitmap(6,15, 0x11aaaa);
			}
		}
		
		public function spawn():void {
			parent.reportEvent( new Array( Manager.event_spawn, this.managedID, this.x, this.y, this.type) );
		}
		
		override public function update():void {
			if(parent.clientSide){
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
			} else {
				super.update();
			}
		}
		
		/**
		 * changes to position, health, and animation to here, so events can be logged by the Manager
		 */
		public function updateTrackedQualities():void {
			super.update();
		}
		
		public override function draw():void {
			FlxG.camera.buffer.copyPixels(bar,new Rectangle(0,0),new Point(this.x+FlxG.camera.x-3,this.y+FlxG.camera.x-6),null,null,true)
			super.draw();
		}
		
	}

}