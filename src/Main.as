package
{
	import org.flixel.*; //Allows you to refer to flixel objects in your code
	import managedobjs.MSLib
	
	[SWF(width="640", height="480", backgroundColor="#000000")] //Set the size and color of the Flash file

	public class Main extends FlxGame
	{
		
		public function Main()
		{
			FlxG.debug=true;
			FlxG.visualDebug=true;
			trace("=============START=============");
			
			MSLib.instanciateMSLib();
			super(640,480,PlayState); //Create a new FlxGame object and load "PlayState"
		}
	}
}