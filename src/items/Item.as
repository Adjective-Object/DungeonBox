package items
{
	import managedobjs.PlayerControlled;
	
	public class Item
	{
		
		protected var owner:PlayerControlled = null;
		public var isUseItem:Boolean;
		public var type:int;
				
		public function setOwner(player:PlayerControlled)
		{
			this.owner = player;
		}
		
		public function onEvent(event:Array)
		{
		
		}
		
		public function update():void
		{
			
		}
		
	}
}