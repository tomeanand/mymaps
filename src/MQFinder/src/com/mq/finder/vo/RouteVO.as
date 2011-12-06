package com.mq.finder.vo
{
	import mx.collections.ArrayCollection;

	public class RouteVO
	{
		public var distance:String;
		public var time:String;
		public var formattedTime:String;
		public var maneuver:ArrayCollection;
		public var destinationOrigination:Array;
		
		public function RouteVO(distance:String,
								time:String, formatTime:String, maneuvers:ArrayCollection,destOrg:Array)
		{
			this.distance = distance;
			this.time = time;
			this.formattedTime = formatTime;
			this.maneuver = maneuvers;
			this.destinationOrigination = destOrg;
		}
	}
}