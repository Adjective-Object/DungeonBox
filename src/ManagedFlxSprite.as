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
		
		public var clientControlled = false;
		
		public static var TYPE_UNDECLARED:int = -1;
		
		public static function getMSType() { return TYPE_UNDECLARED; }
		
		public static var bar:BitmapData = null;
		
		protected var tempx:Number, tempy:Number, temphp:Number;
		
		public function ManagedFlxSprite(x:Number, y:Number, parent:Manager, managedID:int, maxHP:int, clientControlled:Boolean = false) {
			super(x, y);
			this.parent = parent;
			this.managedID = managedID;
			this.type = ManagedFlxSprite.TYPE_UNDECLARED;//no specifically declared type.
			this.makeGraphic(10, 12, 0xff11aa11);
			this.hp = maxHP;
			this.maxHP = maxHP;
			this.drag.x = 10;
			this.clientControlled = clientControlled;
			if(bar==null){			
				bar = FlxG.createBitmap(6,15, 0x11aaaa);
			}
			this.tempx = x;
			this.tempy = y;
			this.temphp = maxHP;
		}
		
		public function spawn():void {
			parent.spawn(this);
		}
		
		override public function update():void {
			//updates game stats only if this is running on the server, or if it is client controlled
			if((parent.clientSide && this.clientControlled) || (!parent.clientSide && !this.clientControlled)){
				this.tempx = this.x;
				this.tempy = this.y;
				this.temphp = this.hp;
				
				updateTrackedQualities();
				super.update();
				
			} else {
				super.update();
			}
		}
		
		override public function postUpdate():void {
			super.postUpdate();
			if( (parent.clientSide && this.clientControlled) || (!parent.clientSide && !this.clientControlled) ){
				if (this.x != tempx || this.y != tempy) {
					parent.updatePosition(this);
				}
				if (this.hp != temphp) {
					parent.updateHealth(this);
					parent.reportEvent( Manager.getDamageEvent(this,temphp-hp) );
				}
			}
		}
		
		/**
		 * changes to position, health, and animation to here, so events can be logged by the Manager
		 */
		public function updateTrackedQualities():void
		{
		}
		
		public override function draw():void {
			FlxG.camera.buffer.copyPixels(bar,new Rectangle(0,0),new Point(this.x+FlxG.camera.x-3,this.y+FlxG.camera.x-6),null,null,true)
			super.draw();
		}
		
		public function xor(lhs:Boolean, rhs:Boolean):Boolean
		{
			return !( lhs && rhs ) && ( lhs || rhs );
		}
		
		override public function kill():void {
			this.parent.kill(this);
			if ( (parent.clientSide && this.clientControlled) || (!parent.clientSide && !this.clientControlled) ){
				super.kill();
			}
		}
			
	}

}