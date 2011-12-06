package com.mq.finder.view
{
	import com.mq.finder.controller.MapManager;
	import com.mq.finder.events.MQFinderEvent;
	import com.mq.finder.model.ModelLocator;
	import com.mq.finder.utils.MQFConstants;
	import com.mq.finder.view.comps.BLIcon;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	
	public class BusinessLocatorBar extends BorderContainer
	{
		public function BusinessLocatorBar()
		{
			super();
		}
		
		protected function searchNearBy(addres:String):void	{
			MapManager.getInstance().dispatchEvent(new MQFinderEvent(MQFConstants.EVENT_SEARCH_ADDR,addres));
		}
		
		protected function createBLocatorList(target:Group):void	{
			var len:int = MQFConstants.BIZ_LOCATOR_LIST.length;
			var icon:BLIcon;
			for(var i:int = 0; i<len; i++)	{
				icon = new BLIcon();
				icon.data = MQFConstants.BIZ_LOCATOR_LIST[i];
				target.addElement(icon);				
			}
		}
	}
}