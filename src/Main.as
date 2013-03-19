package
{
	import org.flixel.*; //Allows you to refer to flixel objects in your code
	import managedobjs.MSLib
		
		[SWF(width="1200", height="600", backgroundColor="#000000")] //Set the size and color of the Flash file
		
		public class Main extends FlxGame
		{
			
			public function Main()
			{
				FlxG.debug=true;
				FlxG.visualDebug=true;
				trace("=============START=============");
				
				MSLib.instanciateMSLib();
				super(1200,600,PlayState); //Create a new FlxGame object and load` "PlayState"
			}
		}
}