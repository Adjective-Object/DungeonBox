package
{
	import org.flixel.*; //Allows you to refer to flixel objects in your code
	import managedobjs.MSLib
	import items.IMLib;
	import flash.events.Event;
		
		[SWF(width="1200", height="600", backgroundColor="#000000")] //Set the size and color of the Flash file
		
		public class Main extends FlxGame
		{
			
			public function Main()
			{
				FlxG.debug=true;
				FlxG.visualDebug=true;
				trace("=============START=============");
				
				MSLib.instanciateMSLib();
				IMLib.instanciateIMLib();
				super(1200,600,MenuState); //Create a new FlxGame object and load the main menu
			}
			
			override protected function create(FlashEvent:Event):void
			{
				super.create(FlashEvent);
				stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
				stage.removeEventListener(Event.ACTIVATE, onFocus);
			}
		}
}