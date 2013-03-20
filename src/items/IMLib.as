package items
{
	import flash.utils.Dictionary
	
	public class IMLib
	{
		public static var managedIDs:Dictionary = new Dictionary();
		
		public static function instanciateIMLib():void 
		{
			IMLib.managedIDs[BlueStone.IMType]=BlueStone;
		}
		
		/**
		 * used to get an item from an ID.
		 * 
		 * @param	type the ID by which the class is registered in MSLib.managedIDs
		 */
		public static function getIMItem(type:int):Item {
			if ( IMLib.managedIDs[type]!=null ) {
				var clazz:Class = IMLib.managedIDs[type];
				return new clazz();
			}
			else
			{
				trace("cannot load item of type",type);
				return new Item();
			}
		}
	}
}