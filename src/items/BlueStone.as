package items
{
	import org.flixel.FlxG;
	import managers.Manager;
	public class BlueStone extends Item
	{
		public static var IMType = 0;
		
		protected static var healCharge = 1;
		protected static var healDelay = 0.5;
		protected static var healValue = 1;
		
		protected var elapsed=0;
		
		[Embed(source = "/../res/BlueRock.png")] private var blueStoneImage:Class;
		
		public function BlueStone()
		{
			this.type = BlueStone.IMType;
			this.image=blueStoneImage;
		}
		
		public override function onEvent(event:Array)
		{
			if(event[0]==Manager.event_damage && event[1]==owner.managedID && event[2]>0){
				this.elapsed=0;
			}
		}
		
		public override function update():void
		{
			elapsed+=FlxG.elapsed;
			if(elapsed>healCharge){
				while(elapsed>healDelay+healCharge ){
					elapsed-=healDelay;
					owner.damage(-healValue);
				}
			}
			
		}
	}
}