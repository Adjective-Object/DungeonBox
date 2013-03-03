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
		public static var distancePlaced = 10;
		
		protected var counter:Number = 0;
		
		[Embed(source="/../res/BurnAOE.png")] private var burnImage:Class;
		
		public function BurnAOE(x:Number, y:Number, parent:Manager, managedID:int)
		{
			super(x, y, parent, managedID, 100);
			this.type = BurnAOE.MSType;
			
			this.loadGraphic(burnImage);
			this.replaceColor(0xffff00ff, 0x00ffffff);
		}
		
		override public function update():void
		{
			super.update();
			this.counter += FlxG.elapsed;
			if (this.counter < fadeDuration) {
				this.alpha = counter / fadeDuration;
			}
			else if (this.counter < fadeDuration+duration) {
				this.alpha = 1;
			}
			else if (this.counter > fadeDuration + duration) {
				this.alpha = (counter-fadeDuration-duration) / fadeDuration;
			}
			else{
				this.kill();
				this.visible = false;
			}
		}
		
		override public function updateTrackedQualities():void
		{
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