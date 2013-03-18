package archetypes
{
	import managedobjs.PlayerDummy;
	import managedobjs.PlayerControlled;
	
	
	public class Archetype
	{
		
		public var moveSpeed:Number = 100;
		public var diagMovespeed:Number = Math.sqrt(2) / 2 * moveSpeed;
		public var dragValue:Number = 16*moveSpeed;
		public var dashSpeed:Number = 2;
		
		public function defineAnimations(player:PlayerDummy):void{
			
		}

		public function update(player:PlayerDummy):void{
			
		}

		public function updateTracked(player:PlayerControlled):void{
			
		}

	}
}