package  
{
	import flash.geom.Point;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxCamera;
	import managedobjs.MSLib;
	import managedobjs.DebuffHandler;
	
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
		protected var knockVelocity:FlxPoint = new FlxPoint(0,0);

		public var managedID:int
		public var type:int;
		public var align:int;
		
		public var clientControlled = false;
		
		public static var TYPE_UNDECLARED:int = -1;
		
		public static function getMSType() { return TYPE_UNDECLARED; }
		
		public var tempx:Number, tempy:Number, temphp:Number;
		public var animname:String;
		public var oldFace:uint;
		
		[Embed(source = "/../res/StunIcon.png")] private var stunIcon:Class;
		[Embed(source = "/../res/GravityWellIcon.png")] private var wellIcon:Class;
		[Embed(source = "/../res/BurnIcon.png")] private var burnIcon:Class;
		[Embed(source = "/../res/SparkIcon.png")] private var sparkIcon:Class;
		
		public var stunned:Boolean = false
		public var displayDebuffIcons:Array = new Array();
		public var debuffDecals:Array = new Array();
		public function displayDebuffIcon(id:int, val:Boolean) {
			this.displayDebuffIcons[id] = val;
		}
		
		
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
			
			this.tempx = x;
			this.tempy = y;
			this.temphp = maxHP;
			this.animname = "none";
			
			displayDebuffIcons[DebuffHandler.STUN] = false;
			debuffDecals[DebuffHandler.STUN] = new FlxSprite(0,0,stunIcon);
			displayDebuffIcons[DebuffHandler.GRAVITY_WELL] = false;
			debuffDecals[DebuffHandler.GRAVITY_WELL] = new FlxSprite(0, 0, wellIcon);
			displayDebuffIcons[DebuffHandler.BURN] = false;
			debuffDecals[DebuffHandler.BURN] = new FlxSprite(0, 0, burnIcon);
			displayDebuffIcons[DebuffHandler.SPARK] = false;
			debuffDecals[DebuffHandler.SPARK] = new FlxSprite(0, 0, sparkIcon);
			
			for (var i:int = 0; i < debuffDecals.length; i++ ) {
				debuffDecals[i].replaceColor(0xffff00ff, 0x00ffffff);
			}
			
		}
		
		public function spawn():void {
			parent.spawn(this);
		}
		
		public function applyDebuff(debuffID:int) {
			parent.applyDebuff(this, debuffID);
		}
		
		public function removeDebuff(debuffID:int) {
			parent.removeDebuff(this, debuffID);
		}
		
		public function damage(damage:int) {
			this.parent.damage(this, 1);
			this.hp -= damage;
		}
		
		override public function update():void {
			//updates game stats only if this is running on the server, or if it is client controlled
			if((parent.clientSide && this.clientControlled) || (!parent.clientSide && !this.clientControlled)){
				this.tempx = this.x;
				this.tempy = this.y;
				this.temphp = this.hp;
				this.oldFace = this.facing;
				if (this._curAnim != null)
				{
					this.animname = this._curAnim.name;
				}
					
				updateTrackedQualities();
				
				if(Math.abs(knockVelocity.x)>0.5 || Math.abs(knockVelocity.y)>0.5){
					PlayState.consoleOutput.text = "ff";
					this.velocity.x=knockVelocity.x;
					this.velocity.y=knockVelocity.y;
					
					knockVelocity.x-=knockVelocity.x*(FlxG.elapsed/0.5);
					knockVelocity.y-=knockVelocity.y*(FlxG.elapsed/0.5);
				}
				
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
				if (this._curAnim != null && this.animname != this._curAnim.name || this.facing!=this.oldFace) {
					parent.updateAnimation(this);
				}
			}
		}
		
		/**
		 * changes to position, health, and animation to here, so events can be logged by the Manager
		 */
		public function updateTrackedQualities():void
		{
			this.stunned=false;
			for (var i:int = 0; i < this.displayDebuffIcons.length; i++) {
				if(displayDebuffIcons[i]){
					DebuffHandler.handleDebuff(this, i);
				}
			}
		}
		
		public override function draw():void {
			super.draw();
			drawDecals();
		}
		
		public function drawDecals():void {
			var dispedIcons:int =0;
			for(var i:int = 0; i<this.displayDebuffIcons.length; i++){
				if(displayDebuffIcons[i]){
					this.debuffDecals[i].x=this.x +dispedIcons*6;
					this.debuffDecals[i].y=this.y+this.height+1;
					this.debuffDecals[i].visible = true;
					this.debuffDecals[i].draw();
					dispedIcons++;
				}
			}
		}
		
		public function xor(lhs:Boolean, rhs:Boolean):Boolean
		{
			return !( lhs && rhs ) && ( lhs || rhs );
		}
		
		override public function kill():void {
			if ( (parent.clientSide && this.clientControlled) || (!parent.clientSide && !this.clientControlled) ){
				this.parent.kill(this);
				super.kill();
			}
		}
		
		public function knockBack(x:int, y:int):void{
			this.knockVelocity.x = x;
			this.knockVelocity.y = y;
		}
			
	}

}