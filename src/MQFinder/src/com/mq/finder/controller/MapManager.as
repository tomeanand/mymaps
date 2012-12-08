// Just updated to check
package com.mq.finder.controller
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class MapManager extends EventDispatcher
	{
		private static var _instance:MapManager;
		
		public function MapManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function getInstance():MapManager	{
			if(_instance == null)	{
				_instance = new MapManager();
			}
			return _instance;
		}
	}
}