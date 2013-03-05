package managedobjs 
{
	
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Maxwell Huang-Hobbs
	 */
	public class ExampleEnemy extends ManagedFlxSprite
	{
		
		[Embed(source = "/../res/Enemy.png")] private var enemy:Class;
		
		public static var MSType:int = 1;
		public static var movespeed:Number = 20;
		public static var sightRange:Number = 50;
		public static var aggroRange:Number = 80;
		
		protected var aggro:Boolean = false;
		protected var lastDamage = 0;
		protected static var damageRefreshTime = 0.25;
		
		public function ExampleEnemy(x:Number, y:Number, parent:Manager, managedID:int) 
		{
			super(x, y, parent, managedID, 10);
			this.type = ExampleEnemy.MSType;
			loadGraphic(enemy, true, true, 11, 15);
			this.replaceColor(0xffff00ff, 0x00ffffff);
			
			addAnimation("stnd", [5,6], 4, true);
			addAnimation("walk", [0, 1, 2, 3, 4, 5], 10, true);
			play("stnd");
			this.drag.x = movespeed / 10;
			this.drag.y = movespeed / 10;
			this.width = 11;
			this.height=15;
			
		}
		
		override public function update():void {
			super.update();
		}
		
		override public function updateTrackedQualities():void {
			lastDamage += FlxG.elapsed;
			var players:Array = this.parent.getPlayers();
			var play:ManagedFlxSprite = players[0];
			for (var i:int = 1; i < players.length; i++ ) {
				if (MSLib.distance(this, players[i]) < MSLib.distance(this, play)) {
					play = players[i];
				}
			}
			var hyp:Number = MSLib.distance(this,play);
			if(hyp>aggroRange){
				this.aggro=false;
			}
			if(hyp<sightRange){
				this.aggro=true;
			}
			
			if (this.aggro)
			{
				walkAt(new FlxPoint(play.x, play.y));
			}
			else {
				 if (FlxG.random() < 0.01) {
					 walkAt(new FlxPoint(this.parent.mapSize.x*FlxG.random(), this.parent.mapSize.y*FlxG.random()));
				 }
				else if (FlxG.random() < 0.001)
				{
					this.velocity.x = 0;
					this.velocity.y = 0;
				}
			}
			
			if (MSLib.overlap(this, play) && lastDamage > damageRefreshTime) {
				lastDamage = 0;
				play.damage(1);
			}
			
			super.updateTrackedQualities();
			
			if (this.velocity.x != 0 || this.velocity.y != 0)
			{
				this.play("walk");
			}
			else
			{
				this.play("stnd");
			}
			
			if (this.velocity.x < 0) {
				this.facing = 1;
			}
			if (this.velocity.x > 0) {
				this.facing = 0;
			}
			
		}
		
		protected function walkAt( p:FlxPoint) {
			var hyp:Number = Math.sqrt( Math.pow(p.x - this.x, 2) + Math.pow(p.y - this.y, 2));

				if(hyp>1){
					var cos = (p.x - this.x) / hyp, sin = (p.y - this.y) / hyp;
					
					this.velocity.x = cos * movespeed;
					this.velocity.y = sin * movespeed;
				}
		}
		
	}

}