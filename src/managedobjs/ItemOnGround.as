package managedobjs
{
	import items.Item;
	import items.IMLib;
	import managers.Manager;
	import ManagedFlxSprite;
	
	public class ItemOnGround extends ManagedFlxSprite
	{
		
		public static var MSType:uint = 6;
		
		protected var internalItem:Item;
		
		protected var canBeCollided:Boolean = true, firstUpdate:Boolean = true;
		
		public function ItemOnGround(x:Number, y:Number, parent:Manager, managedID:int, itemid:int=-1)
		{
			super(x,y,parent,managedID);
			this.type=ItemOnGround.MSType;
			
			this.setState(itemid);
			this.align=Manager.align_none;
		}
		
		public override function changeState(state:int){
			super.changeState(state);
		}
		
		public override function setState(state:int):void{
			super.setState(state);
			this.internalItem = IMLib.getIMItem(state);
			this.loadGraphic(this.internalItem.image);
		}
		
		public override function updateTrackedQualities():void{
			if(firstUpdate || !this.canBeCollided){//TODO this *should* work for preventing picking up items you just dropped, but it is untested
				this.canBeCollided=true;
				for each( var gameObject:ManagedFlxSprite in parent.getAllSprites().members){
					if( gameObject!= null && ( gameObject.type == PlayerDummy.MSType) && MSLib.overlap(gameObject,this)){
						this.canBeCollided=false;
					}
				}
				this.firstUpdate=false;
			} else{
				for each( var gameObject:ManagedFlxSprite in parent.getAllSprites().members){
					if( gameObject!=null && ( gameObject.type == PlayerDummy.MSType) && MSLib.overlap(gameObject,this)){
						parent.giveItem(gameObject,this.internalItem.type);
						var targetPlayer:PlayerDummy = (PlayerDummy)(gameObject);
						if( !this.internalItem.isUseItem || (this.internalItem.isUseItem && targetPlayer.useItem==null) ){
							this.kill();
						} else if (this.internalItem.isUseItem){
							this.changeState(targetPlayer.useItem.type);
							this.firstUpdate=true;
						}
					}
				}
			}
			
			super.updateTrackedQualities();
		}
	}
}