package items
{
	import managedobjs.PlayerDummy;
	
	public class Item
	{
		
		protected var owner:PlayerDummy = null;
		public var isUseItem:Boolean, isConsumable:Boolean;
		public var type:int;
				
		[Embed(source = "/../res/NoItem.png")] private var noItem:Class;
		public var image = noItem;
		
		public function setOwner(player:PlayerDummy)
		{
			this.owner = player;
		}
		
		public function onEvent(event:Array)
		{
		
		}
		
		public function update():void
		{
			
		}
		
		public function onUse(){
			
		}
		
	}
}