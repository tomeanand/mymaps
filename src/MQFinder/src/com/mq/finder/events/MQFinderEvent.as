package com.mq.finder.events
{
	import flash.events.Event;
	
	public class MQFinderEvent extends Event
	{
		public var data:*;
		
		public function MQFinderEvent(type:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}