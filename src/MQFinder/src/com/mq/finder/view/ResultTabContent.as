package com.mq.finder.view
{
	import com.mapquest.tilemap.pois.Poi;
	import com.mq.finder.controller.MapManager;
	import com.mq.finder.events.MQFinderEvent;
	import com.mq.finder.model.ModelLocator;
	import com.mq.finder.utils.MQFConstants;
	import com.mq.finder.view.comps.BusinessListItem;
	import com.mq.finder.view.comps.ItemRoute;
	import com.mq.finder.vo.BusinessCategoryVO;
	import com.mq.finder.vo.BusinessListVO;
	import com.mq.finder.vo.ManeuverVO;
	import com.mq.finder.vo.RouteVO;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	
	import spark.components.NavigatorContent;
	import spark.components.VGroup;
	
	public class ResultTabContent extends NavigatorContent
	{
		[Bindable]public var resultList:BusinessListVO;
		[Bindable]public var routeData:RouteVO
		
		public var isFreshList:Boolean = true;
		public var UI_MODE : String = MQFConstants.MODE_SEARCH;
		
		private var listView:VGroup;
		
		public function ResultTabContent()
		{
			super();
		}
		
		protected function createList(listView:VGroup):void	{
			
			this.listView = listView;
			if(UI_MODE == MQFConstants.MODE_SEARCH)	{
				var list:Array = resultList.list;
				var listItem:Poi;
				var item:BusinessListItem 
				var category:BusinessCategoryVO = resultList.businessCategory;
				for(var i:int = 0; i<list.length; i++)	{
					listItem = list[i] as Poi;
					item = new BusinessListItem();
					item.buzItem = listItem;
					item.category = category;
					item.slNum = (i+1)
					listView.addElement(item);
				}
			}
			else	{
				//this.listView.removeAllElements();
				var routeList:ArrayCollection = routeData.maneuver;
				var cursor:IViewCursor = routeList.createCursor();
				var maneuverVO:ManeuverVO;
				var itemRoute:ItemRoute;
				
				while(!cursor.afterLast)	{
					maneuverVO = cursor.current as ManeuverVO;
					itemRoute = new ItemRoute();
					itemRoute.vo = maneuverVO;
					this.listView.addElement(itemRoute);
					cursor.moveNext();
				}
				
			}
		}
		
		public function refreshList(buVO:BusinessListVO):void{
			if(UI_MODE == MQFConstants.MODE_SEARCH)	{
				this.resultList = buVO;
				listView.removeAllElements();
				createList(listView);
				isFreshList = true;
			}
			else	{
				this.listView.numElements > 0 ? this.listView.removeAllElements() : null
				var routeList:ArrayCollection = routeData.maneuver;
				var cursor:IViewCursor = routeList.createCursor();
				var maneuverVO:ManeuverVO;
				var item:ItemRoute;
				
				while(!cursor.afterLast)	{
					maneuverVO = cursor.current as ManeuverVO;
					item = new ItemRoute();
					item.vo = maneuverVO;
					this.listView.addElement(item);
					cursor.moveNext();
				}
			}
		}
		
		protected function removeList():void	{
			if(UI_MODE == MQFConstants.MODE_SEARCH)	{
				ModelLocator.getInstance().map.removeShapeCollection(resultList.shapeCollection)
				MapManager.getInstance().dispatchEvent(new MQFinderEvent(MQFConstants.EVENT_DELETE_TAB,this));
			}
			else	{
				MapManager.getInstance().dispatchEvent(new MQFinderEvent(MQFConstants.EVENT_DELETE_DIRECTIONS_TAB,this));
			}
		}
		public function removeMe():void	{
			this.parent.removeChild(this);
		}
	}
}