package
{
	import flash.events.KeyboardEvent;
	
	import org.flixel.*;
	
	public class InputText extends FlxText
	{
		public var responsive:Boolean;
		
		public function InputText(X:Number, Y:Number, Width:uint, EmbeddedFont:Boolean=true, responsive:Boolean=true)
		{
			super(X,Y,Width,null,EmbeddedFont);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, processKeystrokeDOWN);
			this.responsive=responsive;
		}
		
		public function processKeystrokeDOWN(keyEvent:KeyboardEvent):void{
			if(this.responsive){
				if( 
					(65<=keyEvent.keyCode && keyEvent.keyCode<=90)|| //letters
					(48<=keyEvent.keyCode && keyEvent.keyCode<=57)|| //numbers
					(96<=keyEvent.keyCode && keyEvent.keyCode<=111)|| //numpad
					(186<=keyEvent.keyCode && keyEvent.keyCode<=191) //special chars
					){
					if(this.text==null){
						this.text="";
					}
					this.text= this.text+String.fromCharCode(keyEvent.charCode);
				}
				
				if(keyEvent.keyCode==8){//backspace
					this.text = this.text.slice(0,this.text.length-1);
				}
			}
		}
		
		
		public override function destroy():void{
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, processKeystrokeDOWN);
			super.destroy();
		}
	}
}