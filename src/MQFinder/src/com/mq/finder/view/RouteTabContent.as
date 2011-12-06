package com.mq.finder.view
{
	import com.mq.finder.view.comps.ItemRoute;
	import com.mq.finder.vo.ManeuverVO;
	import com.mq.finder.vo.RouteVO;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	
	import spark.components.NavigatorContent;
	import spark.components.VGroup;
	
	public class RouteTabContent extends NavigatorContent
	{
		public var listView:VGroup;
		
		[Bindable]public var routeData:RouteVO
		
		public function RouteTabContent()
		{
			super();
			
		}
		
		protected function createList(listView:VGroup):void	{
			this.listView = listView;
			this.listView.removeAllElements();
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
		
		public function refreshList():void	{
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
}