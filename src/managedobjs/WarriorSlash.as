package managedobjs
{
	import managers.Manager;
	
	public class WarriorSlash extends ManagedFlxSprite
	{
		public static var MSType:uint = 8;
		public static var width:uint = 8;
		
		[Embed(source = "/../res/WarriorSlash.png")] private var SlashImage:Class;
		
		protected var collisionRecord:Array = new Array();
		
		//0,1,2 -> left
		//3,4,5 -> right
		public function WarriorSlash(x:int, y:int, parent:Manager, managedID:int, state:int=0)
		{
			super(x,y,parent,managedID);
			this.type=WarriorSlash.MSType;
			this.loadGraphic(SlashImage,true,true,8,16,false);
			this.replaceColor(0xffff00ff, 0x00ffffff);
			this.addAnimation("slas",[0,1,2,3,4,5,5],15,false);
			play("slas");
			this.setState(state);
		}
		
		public override function updateTrackedQualities():void{
			
			if(this.state>2){
				this.facing=1;
			} else{
				this.facing=0;
			}
			
			for each( var gameObject:ManagedFlxSprite in parent.getAllSprites().members)
			{
				if( gameObject!=null && gameObject.align != this.align && gameObject.align!=Manager.align_none && !collisionRecord[gameObject.managedID] && MSLib.overlap(this, gameObject))
				{
					collisionRecord[gameObject.managedID] = true;
					gameObject.damage( this.getDamage() );
					if(this.state % 3 == 2){
						if(this.facing==1){
							this.parent.knockBack(gameObject, 30, 0);
						}
						else if (this.facing==0){
							this.parent.knockBack(gameObject,-30,0);
						}
					} else{
						if(this.facing==1){
							this.parent.knockBack(gameObject, 5, 0);
						}
						else if (this.facing==0){
							this.parent.knockBack(gameObject,-5,0);
						}
					}
				}
			}
			
			if(this.getCurFrame()==this.getCurAnim().frames.length-1){
				this.kill();
			}
		}
		
		protected function getDamage():uint{
			switch(this.state%3){
				case 0:
					return 3;
				case 1:
					return 3;
				case 2:
					return 7;
			}
			return 0;
		}
	}
}