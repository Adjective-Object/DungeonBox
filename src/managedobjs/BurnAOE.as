package managedobjs 
{
	import org.flixel.*;

	
	/**
	 * ...
	 * @author Maxwell Huang-Hobbs
	 */
	public class BurnAOE extends ManagedFlxSprite
	{
		public static var MSType = 4;
		public static var duration = 5, fadeDuration=0.5;
		public static var distancePlaced = 20;
		public static var nullWidth = 8;
		
		protected var counter:Number = 0;
		protected var applyBuffs:Boolean = false;
		
		[Embed(source="/../res/BurnAOE.png")] private var burnImage:Class;
		
		public function BurnAOE(x:Number, y:Number, parent:Manager, managedID:int)
		{
			super(x, y, parent, managedID, 100);
			this.type = BurnAOE.MSType;
			
			this.loadGraphic(burnImage);
			this.replaceColor(0xffff00ff, 0x00ffffff);
			nullWidth = this.width;
			applyBuffs = false;
		}
		
		override public function update():void
		{
			super.update();
			this.counter += FlxG.elapsed;
			if (this.counter < fadeDuration) {
				this.alpha = counter / fadeDuration;
				this.scale.x = 2 - this.alpha;
				this.scale.y = 2 - this.alpha;
			}
			else if (this.counter < fadeDuration+duration) {
				this.alpha = 1;
				applyBuffs = true;
			}
			else if (this.counter > fadeDuration + duration) {
				applyBuffs = false;
				this.alpha = 1- (counter-fadeDuration-duration) / fadeDuration;
				this.scale.x = 3 - 2*this.alpha;
				this.scale.y = 3 - 2*this.alpha;
			}
			else{
				this.kill();
				this.visible = false;
			}
		}
		
		override public function updateTrackedQualities():void
		{
			if(this.applyBuffs){
				for each( var gameObject:ManagedFlxSprite in parent.getAllSprites().members)
				{
					if( gameObject.align != this.align && FlxG.overlap(this, gameObject))
					{
						gameObject.applyDebuff(DebuffHandler.BURN);
					}
				}
				super.updateTrackedQualities();
			}
		}
		
		
		
	}

}