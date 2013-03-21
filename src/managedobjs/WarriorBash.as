package managedobjs
{
	import managedobjs.*;
	import managedobjs.DebuffHandler;
	
	import managers.*;
	
	import org.flixel.FlxGroup;
	
	public class WarriorBash extends ManagedFlxSprite
	{
		
		public static var MSType:uint = 9;
		public static var offset:uint = 4;
		public static var width:uint = 4;
		public static var bashFrame = 2;
		
		public static var knockback = 30;
		
		[Embed(source = "/../res/WarriorBash.png")] private var BashImage:Class;
		
		protected var collided:Array = new Array();
		
		public function WarriorBash(x:int, y:int, parent:Manager, managedID:int)
		{	
			super(x,y,parent,managedID);
			this.type=WarriorBash.MSType;
			this.loadGraphic(BashImage,true,true,8,16,false);
			this.replaceColor(0xffff00ff, 0x00ffffff);
			this.addAnimation("bash",[0,1,2,3,4,5,5],15,false);
			play("bash");
		}
		
		override public function updateTrackedQualities():void
		{
			if(this._curFrame >= WarriorBash.bashFrame){
				for each( var gameObject:ManagedFlxSprite in this.parent.getAllSprites().members)
				{
					if( gameObject!=null && !this.displayDebuffIcons[DebuffHandler.BURN] && gameObject.align != this.align && gameObject.align!=Manager.align_none && MSLib.overlap(this, gameObject))
					{
						
						if(collided[gameObject.managedID]==null){
							collided[gameObject.managedID]=true;
							if (gameObject.displayDebuffIcons[DebuffHandler.SPARK]){
								gameObject.applyDebuff(DebuffHandler.STUN);
								gameObject.removeDebuff(DebuffHandler.SPARK);
							} else{
								gameObject.applyDebuff(DebuffHandler.SPARK);
							}
							if(this.facing==1){
								gameObject.knockBack(knockback,0);
							} else{
								gameObject.knockBack(-knockback,0);
							}
						}
					}
				}
				super.updateTrackedQualities();
			}
			if(this.getCurFrame()==this.getCurAnim().frames.length-1){
				this.kill();
			}
		}
	}
}