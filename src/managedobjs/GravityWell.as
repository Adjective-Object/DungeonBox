package managedobjs
{
	import managedobjs.DebuffHandler;
	
	import org.flixel.*;
	
	public class GravityWell extends ManagedFlxSprite
	{
		[Embed(source = "/../res/GravityWell.png")] private var wellSprite:Class;
		
		public static var MSType:int = 3, chargeTime = 0.5, drawTime = 0.2, drawDist = 100;
		
		protected var elapsed:Number = 0;
		protected var captured = null, capturedCoords = null;
		
		public function GravityWell(x:Number, y:Number, parent:Manager, managedID:int) 
		{
			super(x,y,parent, managedID, 0);
			this.type=GravityWell.MSType;
			
			this.loadGraphic(wellSprite);
			this.replaceColor(0xffff00ff, 0x00ffffff);
			
			this.offset.x=this.width/2;
			this.offset.y=this.height/2;
		}
		
		override public function update():void{
			super.update();
			elapsed+=FlxG.elapsed;
			
			if(elapsed<chargeTime){
				this.alpha = elapsed / chargeTime;
				if(captured==null)
				{
					this.captured=new Array();
					for each( var gameObject:ManagedFlxSprite in parent.getAllSprites().members)
					{
						if(gameObject!= null && gameObject.align!=this.align && MSLib.distance(this,gameObject)<=GravityWell.drawDist){
							this.captured.push(gameObject.managedID);
							gameObject.applyDebuff(DebuffHandler.GRAVITY_WELL);
						}
					}
				}
			}else if (this.elapsed < chargeTime + drawTime) {
				if(capturedCoords==null)
				{
					this.alpha = 1;
					this.capturedCoords=new Array();
					for (var cap:int = 0; cap < captured.length; cap++ )
					{
						var gameObject:ManagedFlxSprite = this.parent.getEntity(captured[cap]);
						this.capturedCoords.push(new FlxPoint(gameObject.x, gameObject.y));
					}
				}
				
				var fracComplete:Number = (elapsed-chargeTime)/drawTime;
				
				for(var i:int=0; i<captured.length; i++){
					PlayState.consoleOutput.text = "CAP";
					this.parent.getEntity(captured[i]).x=
						this.capturedCoords[i].x+(this.x-this.capturedCoords[i].x)*fracComplete;
					this.parent.getEntity(captured[i]).y=
						this.capturedCoords[i].y+(this.y-this.capturedCoords[i].y)*fracComplete;
				}
				
				this.scale.x = 1- fracComplete;
				this.scale.y = 1- fracComplete;
			}else {
				if(this.alive && this.visible){
					if(captured!=null){
						for each( var cap:int in captured){
							parent.getEntity(cap).removeDebuff(DebuffHandler.GRAVITY_WELL);
						}
					}
				}
				this.visible=false;
				this.kill();
			}
			
			
		}
	}
}