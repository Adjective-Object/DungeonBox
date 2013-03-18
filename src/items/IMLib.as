package items
{
	import flash.utils.Dictionary
	
	public class IMLib
	{
		public static var managedIDs:Dictionary = new Dictionary();
		
		public static function instanciateIMLib():void 
		{
			managedIDs[BlueStone.IMType]=BlueStone;
		}
		
		/**
		 * used to get an item from an ID.
		 * 
		 * @param	type the ID by which the class is registered in MSLib.managedIDs
		 */
		public static function getIMItem(type:int):ManagedFlxSprite {
			if (type != ManagedFlxSprite.TYPE_UNDECLARED) {
				var clazz:Class = IMLib.managedIDs[type];
				return new clazz();
			}
			else
			{
				return new BlueStone();
			}
		}
	}
}