package com.mq.finder.view
{
	import com.mapquest.LatLng;
	import com.mapquest.tilemap.ShapeCollection;
	import com.mq.finder.controller.MapManager;
	import com.mq.finder.events.MQFinderEvent;
	import com.mq.finder.model.ModelLocator;
	import com.mq.finder.utils.MQFConstants;
	import com.mq.finder.view.comps.ResultTabContentView;
	import com.mq.finder.view.comps.RouteTabContentView;
	import com.mq.finder.vo.BusinessCategoryVO;
	import com.mq.finder.vo.BusinessListVO;
	import com.mq.finder.vo.RouteVO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.containers.Accordion;
	import mx.containers.TabNavigator;
	import mx.events.IndexChangedEvent;
	
	import spark.components.BorderContainer;
	import spark.effects.Resize;
	
	public class InfoPanel extends BorderContainer
	{
		[Bindable]protected var isDocked:Boolean = false;
		[Bindable]protected var dockImg:Class = MQFConstants.IMG_DOCOPEN;
		[Bindable]protected var isInfoInitialised:Boolean = false;
		
		protected var model:ModelLocator = ModelLocator.getInstance();
		
		protected var resizer:Resize = new Resize(this);
		private var isDeleted:Boolean = false;
		private var lastPoiCollection:ShapeCollection;
		private var directionsTabIndex:Number = 0;
		
		
		public var resultTabs:TabNavigator;
		private var directionsTab:TabNavigator;
		private var directionsView:ResultTabContent
		
		
		public function InfoPanel()
		{
			super();
			initialise()
		}
		
		private function initialise():void	{
			dockImg = MQFConstants.IMG_DOCOPEN;
			MapManager.getInstance().addEventListener(MQFConstants.EVENT_CREATE_TAB,createTab);
			MapManager.getInstance().addEventListener(MQFConstants.EVENT_DELETE_TAB,deleteTab);
			MapManager.getInstance().addEventListener(MQFConstants.EVENT_BLOCATOR_REMOVE,removeTab);
			MapManager.getInstance().addEventListener(MQFConstants.EVENT_REFRESH_TABS,refreshTabs);
			MapManager.getInstance().addEventListener(MQFConstants.EVENT_CHECK_SEARCH_CONTEXT,checkSearchContext);
			
			MapManager.getInstance().addEventListener(MQFConstants.EVENT_SHOW_DIRECTION,showDirectionsTab);
			MapManager.getInstance().addEventListener(MQFConstants.EVENT_DELETE_DIRECTIONS_TAB,removeDirectionTab);
			
		}
		private function createTab(event:MQFinderEvent):void	{
			isInfoInitialised = true;
			
			var tabView:ResultTabContentView = new ResultTabContentView();
			tabView.resultList = event.data as BusinessListVO;
			tabView.icon = tabView.resultList.businessCategory.selectedIcon;
			resultTabs.addItem(tabView);
			resultTabs.selectedIndex = resultTabs.length-1;
			
			isDocked ? dockPanel() : null;
		}
		private function deleteTab(event:MQFinderEvent):void	{
			isDeleted = true;
			var tabView:ResultTabContentView = event.data as ResultTabContentView;
			
			var resultList:ArrayCollection = model.searchResults;
			var deletedBuzList:BusinessListVO = tabView.resultList as BusinessListVO;
			var cursor:IViewCursor = resultList.createCursor();
			var buzList:BusinessListVO;
			
			while(!cursor.afterLast)	{
				buzList = cursor.current as BusinessListVO;
				if(buzList.businessCategory.category == deletedBuzList.businessCategory.category)	{
					model.map.removeShapeCollection(buzList.shapeCollection);
					cursor.remove();
				}
				cursor.moveNext();
			}
			//resultTabs.removeChild(tabView);
			tabView.removeMe();
			
			if(resultTabs.length>0)	{
				var tabItem:ResultTabContentView = resultTabs.selectedChild as ResultTabContentView;
				model.map.addShapeCollection(tabItem.resultList.shapeCollection)
			}
			isInfoInitialised = resultTabs.length == 0 ? false : true;
		}
		private function removeTab(event:MQFinderEvent):void	{
			isDeleted = true;
			var catVO:BusinessCategoryVO = event.data;
			var tabs:Array = resultTabs.getChildren();
			var tabView:ResultTabContentView;
			for(var i:int = 0; i<tabs.length; i++)	{
				tabView = (tabs[i]) as ResultTabContentView;
				if(tabView.resultList.businessCategory.category == catVO.category)	{
					model.map.removeShapeCollection(tabView.resultList.shapeCollection);
					model.removeShapeCollection(catVO.category);
					//resultTabs.removeChild(tabView);
					tabView.removeMe();
					break;
				}
			}
			if(resultTabs.length>0)	{
				var tabItem:ResultTabContentView = resultTabs.selectedChild as ResultTabContentView;
				model.map.addShapeCollection(tabItem.resultList.shapeCollection)
			}
			isInfoInitialised = resultTabs.length == 0 ? false : true;
		}
		

		private function refreshTabs(event:MQFinderEvent):void	{
			var tabs:Array = resultTabs.getChildren();
			var tabView:ResultTabContentView;
			var buVO:BusinessListVO;
			var tobeRefreshBuzListVO:BusinessListVO = event.data as BusinessListVO;
			for(var i:int = 0; i<tabs.length; i++)	{
				tabView = (tabs[i]) as ResultTabContentView;
				buVO = tabView.resultList;
				if(buVO.businessCategory.category == tobeRefreshBuzListVO.businessCategory.category)	{
					tabView.refreshList(tobeRefreshBuzListVO);	
					break;
				}
			}
		}
		
		private function checkSearchContext(event:MQFinderEvent):void	{
			if(resultTabs.length>0)	{
				//changing all the result list content in ResultTabContent to "OLD list"
				// flag isFreshList to false in ResultTabContent;
				obsoleteBusinessResultList();
				var tabView:ResultTabContentView = resultTabs.selectedChild as ResultTabContentView;
				//sending BusinessListVO
				MapManager.getInstance().dispatchEvent(new MQFinderEvent(MQFConstants.EVENT_REFRESH_BLOCATOR,tabView.resultList));
			}
		}
		
		
		private function obsoleteBusinessResultList():void	{
			var tabs:Array = resultTabs.getChildren();
			var tabView:ResultTabContentView;
			for(var i:int = 0; i<tabs.length; i++)	{
				tabView = (tabs[i]) as ResultTabContentView;
				tabView.isFreshList = false;
			}
		}
		
		protected function onTabSelectEvent(event:IndexChangedEvent):void	{
			var latLng:LatLng = model.map.center;
			if(lastPoiCollection != null)	{
				model.map.removeShapeCollection(lastPoiCollection);
			}
			var selectedTab:ResultTabContentView = resultTabs.getItemAt(event.newIndex) as ResultTabContentView;
			//model.map.removeShapeCollection(lastTab.resultList.shapeCollection);
			// if the scope of the map is changed then changing the shape collection 
			//triggering a seach again
			if(selectedTab.UI_MODE == MQFConstants.MODE_SEARCH)	{
				if(((latLng.lat == selectedTab.resultList.latLng.lat) && (latLng.lng == selectedTab.resultList.latLng.lng)) || selectedTab.isFreshList )	{
					model.map.addShapeCollection(selectedTab.resultList.shapeCollection);
					lastPoiCollection = selectedTab.resultList.shapeCollection;
				}
				else	{
					//sending BusinessListVO
					MapManager.getInstance().dispatchEvent(new MQFinderEvent(MQFConstants.EVENT_REFRESH_BLOCATOR,selectedTab.resultList));
				}
			}
			else	{
				
			}
		
			
			
		}
		
		protected function addHandler(comps:TabNavigator):void	{
			this.resultTabs = comps;
			this.resultTabs.addEventListener(IndexChangedEvent.CHANGE,onTabSelectEvent);
		}
		/**
		 * 
		 * 
		 * 
		 * 
		 * */
		
		private function showDirectionsTab(event:MQFinderEvent):void	{
			model.map.infoWindow.hide();
			if(!model.isDirectionInitialised)	{
				model.isDirectionInitialised = true;
				directionsView = new ResultTabContentView();
				directionsView.UI_MODE = MQFConstants.MODE_ROUTE
				directionsView.routeData = event.data as RouteVO;
				directionsView.label = "Route to "+directionsView.routeData.destinationOrigination[directionsView.routeData.destinationOrigination.length-1]
				resultTabs.addItem(directionsView);
				resultTabs.selectedIndex = resultTabs.length-1;
				directionsTabIndex = resultTabs.selectedIndex;
			}
			else	{
				directionsView.routeData = event.data as RouteVO;
				directionsView.label = "Route to "+directionsView.routeData.destinationOrigination[directionsView.routeData.destinationOrigination.length-1]
				directionsView.refreshList(null);
				resultTabs.selectedIndex = directionsTabIndex;
			}
		}
		
		private function removeDirectionTab(event:MQFinderEvent):void	{
			isDeleted = true;
			directionsTabIndex = 0;
			var tabView:ResultTabContentView = event.data as ResultTabContentView;
			model.isDirectionInitialised = false;
			tabView.removeMe();
		}
		

		
		protected  function dockPanel():void	{
			MapManager.getInstance().dispatchEvent(new MQFinderEvent(MQFConstants.EVENT_RESIZEMAP,isDocked));
			if(!isDocked)	{
				resizer.widthFrom = this.width; resizer.widthTo = 10;
				resizer.play();
				isDocked = true;
				dockImg = MQFConstants.IMG_DOCCLOSE;
				isInfoInitialised = false;
			}
			else	{
				resizer.widthFrom = this.width; resizer.widthTo = 350;
				resizer.play();
				isDocked = false;
				dockImg = MQFConstants.IMG_DOCOPEN;
				isInfoInitialised = resultTabs.length == 0 ? false : true;
			}
		}
	}
}